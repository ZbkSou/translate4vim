if !has('python')
    echo "Sorry, Caiyun Translator requires python support"
    finish
endif
 
python << EOF
 
import requests
import json
import vim

 
class CaiyunTranslator:
    
    def translate(self,source ):
        if self.is_Chinese(source):
	   direction = 'zh2en'
	else:
	   direction = 'auto2zh'
	   
        url = "http://api.interpreter.caiyunai.com/v1/translator"
        token = "ubtp5endxulsio6tfkz8"
        payload = {
            "source" : source, 
            "trans_type" : direction,
            "request_id" : "demo",
            "detect": True,
            }
        headers = {
            'content-type': "application/json",
            'x-authorization': "token " + token,
        }
        response = requests.request("POST", url, data=json.dumps(payload), headers=headers)
        return json.loads(response.text)['target']
    
    def is_Chinese(self,word):
        for ch in word:
            if '\u4e00' <= ch <= '\u9fff':
                return True
        return False
tr = CaiyunTranslator()
Cmd=vim.command
EOF
 
function! s:Translate(text)
python << EOF
print tr.translate(vim.eval("a:text"))
EOF
endfunction
 
function! s:TranslateWR(text)
python << EOF
res = tr.translate(vim.eval("a:text"))
print res
if res:
    Cmd('normal daw')
    Cmd('let @t="%s"' % (res) )
    Cmd('normal "tp')
EOF
endfunction

function! s:TranslateEOLR(text)
python << EOF
res = tr.translate(vim.eval("a:text"))
print res
if res:
    Cmd('normal dd')
    Cmd('let @t="%s"' % (res) )
    Cmd('normal "tp')
EOF
endfunction

function! TranslateCWORD()
    call s:Translate(expand("<cword>"))
endfunction
 
function! TranslateCWORDR()
    call s:TranslateWR(expand("<cword>"))
endfunction

function! TranslateVISUAL()

    call s:Translate(getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1])
endfunction
 
function! TranslateEOL()
    call s:Translate(strpart(getline("."), col(".")-1))
endfunction
 
function! TranslateEOLR()
    call s:TranslateEOLR(strpart(getline("."), col(".")-1))
endfunction
command!  -nargs=0 TWR call TranslateCWORDR()
command!  -nargs=0 TW call TranslateCWORD()
command!  -nargs=0 TLR call TranslateEOLR()
command!  -nargs=0 TL call TranslateEOL()
