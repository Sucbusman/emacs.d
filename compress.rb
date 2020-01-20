#!/bin/ruby
# 1. parse a elisp file, search "load-relative-lib" cmd
# and populate this position with library elisp file which
# are recursivly handle with the same progress
# 2. report some syntax error,eg.unmatched parenthesis
DIR =  File.dirname __FILE__
if ARGV.length < 1
  INIT = DIR+"/template_init.el"
  OUTPUT = DIR+"/init.el"
else
  INIT = ARGV[0]
  if ARGV.length >= 2
    OUTPUT = ARGV[1]
  else
    OUTPUT = DIR+"./init.el"
  end
end


class Token < Struct.new :type,:literal,:line,:column
  def to_s
    "<#{type.to_s} #{literal.to_s} >"
  end
  def to_elisp
    literal
  end
  def position
    "line:#{line} column:#{column}"
  end
end

def is_quote tok
  case tok.type
  when :QUOTE,:BACK_QUOTE,:HASH_QUOTE
    true
  else
    false
  end
end

def is_unquote tok
  case tok.type
  when :UN_QUOTE,:UN_QUOTE_FLAT
    true
  else
    false
  end
end

class Expr < Struct.new :function,:args
  #f:Token args:[Token,...]
  def to_s
    "(#{function.to_s} #{args.reduce {|i,j| "#{i.to_s},#{j.to_s}"}})"
  end
  def build i
    if i.is_a? Expr or i.is_a? Token 
      i.to_elisp 
    else
      i.to_s 
    end
  end
  def to_elisp
    "(#{build function}#{
    s=' ';
    for arg in args
      s += build arg
      if not arg.is_a? Token or not ((is_quote(arg) or is_unquote(arg)))
        s+=' '
      end
    end
    s
    })"
  end
end

class Scanner
  IDENTIFIER = /[&:@_a-zA-Z\+\-\*\/!\?><]/
  IDENTIFIER2 = /[&:@_a-zA-Z\+\-\*\/!\?><0-9]/
  def initialize source
    @source = source
    @start = 0
    @current = 0
    @line = 1
    @total_char_until_last_line = 0
  end
  def eof? pos=@current
    pos >= @source.length
  end
  def peek
    if eof?
      :EOF
    else
      @source[@current]
    end
  end
  def peek_next
    if eof?(@current+1)
      :EOF
    else
      @source[@current+1]
    end
  end
  def nextChar
    c=peek
    @current += 1
    c
  end
  def tok_finish
    @start = @current
  end
  def is_blank? s
    ["\n",' ',"\t"].include? s
  end
  def skipUntil(&condition)
    #skip from current until condition
    #which includes current char, but not includes the last unsatisfiable char
    until (c=peek()) == :EOF
      if yield(c)
        break
      elsif c=="\n"
        @line +=1
        @total_char_until_last_line = @current
        nextChar
      else
        nextChar
      end
    end 
  end
  def get_column
    @start+1-@total_char_until_last_line
  end
  def get_token type
    tok_str = @source[@start,@current-@start]
    column = get_column
    tok_finish
    Token.new type,tok_str.strip,@line,column
  end
  def error s
    STDERR.puts "At line #{@line} column #{get_column}:#{s}"
    exit! 1
  end
  def fetch
    while not eof?
      c = nextChar
      case c
      when ';'
        skipUntil {|c| c=="\n"}
        tok_finish
      when '['
        return get_token :LEFT_BRACKET
      when ']'
        return get_token :RIGHT_BRACKET
      when '"'
        return tok_string
      when "'"
        return get_token :QUOTE
      when "?"
        if peek == '\\'
          nextChar
        end
        nextChar
        return get_token :CHAR
      when '`'
        return get_token :BACK_QUOTE
      when '#'
       if peek == "'"
         nextChar
         return get_token :HASH_QUOTE
       else
        error("HASH_QUOTE expect ' after #")
       end
      when ","
        if peek == '@'
          nextChar
          return get_token :UN_QUOTE_FLAT
        else
          return get_token :UN_QUOTE
        end
      when '('
        return get_token :LEFT_PAREN
      when ')'
        return get_token :RIGHT_PAREN
      when '0'..'9'
        return tok_number
      when '.'
        c = peek
        if [*'0'..'9'].include? c
          return tok_number
        elsif is_blank? c
          return get_token :DOT
        elsif c.match IDENTIFIER
          return tok_identifier
        else
          error("Expect number or blank or identifier but get #{c} #{c.ord}")
        end
      when IDENTIFIER
        return tok_identifier
      when "\n"
        @line += 1
        @total_char_until_last_line = @current
        tok_finish
      else
        #omit
        tok_finish
      end
    end 
    Token.new :EOF,nil,@line
  end
  def tok_identifier
    skipUntil {|c| not c.match IDENTIFIER2}
    get_token :IDENTIFIER
  end
  def tok_number
    skipUntil {|c| not c.match(/[0-9]/) }
    if peek == '.'
      nextChar
      skipUntil {|c| not c.match(/[0-9]/) }
    elsif (peek).match IDENTIFIER
      return tok_identifier
    end
    get_token :NUMBER
  end
  def tok_string
    skipUntil {|c| c=='"'}
    nextChar #eat closing quote
    get_token :STRING
  end
end

class Parser
  def initialize scanner
    @source  = scanner
    @current = @source.fetch
    @next    = @source.fetch
    @ast     = [] #[ Expr,...]
    @pairs   = [] #[ Token,...] Token = LeftParen|RightParen
  end
  def next_token
    now = @current
    @current = @next
    @next = @source.fetch
    now
  end
  def peek
    @current
  end
  def peek_next
    @next
  end
  def atEnd
    @current != nil and @current.type == :EOF
  end
  def parse
    begin
      add expression
    end until atEnd
    @ast
  end
  def add i
    @ast.append i
  end
  def error s
    STDERR.puts("[Parsing] At #{@current.position}: #{s} in context #{@pairs[-1].position if @pairs[-1]}")
    exit! 1
  end
  def update_pairs tok
    stacktop = @pairs[-1]
    if not stacktop
      @pairs.push tok
    elsif stacktop.type == tok.type 
      @pairs.push tok
    else
      @pairs.pop 
    end
  end
  def expression
    if atEnd
      error("Expect expression but find EOF")
    end
    tok = peek
    if tok.type == :LEFT_PAREN
      update_pairs tok
      if peek_next.type == :RIGHT_PAREN
        update_pairs peek_next
        expr = Token.new :NOP,'()',peek_next.line
        next_token
        next_token
        expr
      else
        next_token #eat left parenthesis
        arr = []
        begin
          arr.append expression
        end until peek.type == :RIGHT_PAREN
        update_pairs peek
        next_token #eat closing right parenthesis
        f,*args = arr
        Expr.new f,args
      end
    else
      atom
    end
  end
  def atom
    if not atEnd
      next_token
    else
      error("Expect atom but find EOF")
    end
  end
end

class Compiler
  def initialize ast,name='ans'
    @ast = ast
    @name = name
    @out = ''
    @suffix = '.el'
    @myname = __FILE__.split("/")[-1]
  end
  def newline
    @out += "\n"
  end
  def separator_end
    @out += ";;===end===\n"
  end
  def separator libname
    @out += ";;===Added by #{@myname} with #{libname.to_s}===\n"
  end
  def wrapper s,sep_str
    newline
    separator sep_str
    @out += s
    newline
    separator_end
  end
  def strip_side s
    s[1,s.length-2]
  end
  def validate_string s
    if s[0] == '"' and s[-1] == '"' 
      true else false end
  end
  def load_lib fname
    if not validate_string fname
      STERR.puts "[Runtime] expect string but not find quote"
      exit! 1
    end
    File.open(DIR+"/#{strip_side fname}#{@suffix}") do |f|
      source = f.read()
      scanner = Scanner.new source
      parser  = Parser.new scanner
      compiler = Compiler.new  parser.parse
      compiler.generate
    end
  end
  def generate
    @ast.each do |expr|
      f,args = expr.function,expr.args
      if f.type == :IDENTIFIER and  
        f.literal == "load-relative-lib"
        libname = args[0].literal
        wrapper (load_lib libname),libname+@suffix
      else
        @out += expr.to_elisp
      end
    end
    @out
  end
  def write
    File.open @name,"w" do |f|
      f.write @out
    end
  end
  def run
    generate
    write
  end
end


File.open(INIT) {|init|
  Source = init.read() 
}

def test_scanner
  scanner = Scanner.new Source
  until (tok = scanner.fetch).type == :EOF do
    p tok
  end
end

def test_parser
  scanner = Scanner.new Source
  parser = Parser.new scanner
  ast = parser.parse
  ast.each {|expr|
    puts expr.to_elisp
  }
end

def main
  scanner  = Scanner.new Source
  parser   = Parser.new scanner
  compiler = Compiler.new (parser.parse),OUTPUT
  compiler.run
end

#test_scanner
#test_parser
if $PROGRAM_NAME == __FILE__
  main
  puts "ok"
end
