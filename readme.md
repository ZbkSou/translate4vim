将translate.vim放在~/.vim/plugin/目录下
放在这个目录下的目的是为了让这个plugin可以自动加载

当然你也可以放在任意位置，然后在~/.vimrc中添加如下命令：
source 你的vim插件位置,本示例为~/translate.vim
一个完整的示例为：
source ~/translate.vim