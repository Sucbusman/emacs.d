(defun loadApiKey nil
  (setq apiFilePath (getenv "EmacsAIPath"))
    (let ((c (read-file-content apiFilePath)))
      (caesar-encrypt c -6)))

(use-package gptel
:ensure t
:config
(setq
    gptel-model 'deepseek-ai/DeepSeek-V3
    gptel-backend (gptel-make-deepseek "DeepSeek"
    :host "api.siliconflow.cn"
    :stream t
    ;;:key "sk-xxxxxxxxxx"
    :key (loadApiKey)
    :models '((deepseek-ai/DeepSeek-R1
            :capabilities (tool reasoning)
            :context-window 64
            :input-cost 0.55
            :output-cost 2.19)
            (deepseek-ai/DeepSeek-V3
                :capabilities (tool)
                :context-window 64
                :input-cost 0.27
                :output-cost 1.10))
    ))
;;(setq gptel-log-level 'info)
)

;;(write-bytes-to-file (caesar-encrypt "sk-xxxx" 6) apiFilePath)
