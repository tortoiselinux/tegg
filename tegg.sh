#!/usr/bin/env bash
#========================{CABEÇALHO}=======================|
#
#AUTOR:
#   wellyton 'welly' <welly.tohn@gmail.com>
#
#NOME: tegg.sh
#
#
#DESCRIÇÃO:
#   esse é o gerenciador e instalador de programas e scripts
#   tegg! O dever desse programa é baixar e atualizar cada um
#   dos scripts necessários e suas dependências.
#   Além disso, ele dá suporte aos desenvolvedores, gerando
#   templates para que crie os seus próprios no padrão do projeto
#   tortoise!
#
#LICENÇA:
#   MIT
#
#CHANGELOG:
#   VERSÃO 0.0.1 - BETA
#
#   Descrição:
#       versão inicial
#   alterações:
#       - criado funções básicas (instalar, remover, atualizar - ainda não funcional, configurar)
#       - criado função de template
#
#   VERSÃO 0.0.2 - BETA
#   
#   Descrição:
#       problema de arquivo e diretórios vindo vazios resolvidos
#       
#   alterações
#       - erros no código corrigidos
#       - curl substituído por wget

# VARIAVEIS GLOBAIS

script_dir="$HOME/scripts"
src_dir="$HOME/scripts/src"
links_dir="$HOME/scripts/symlinks"

uso=" 
$(basename $0) {OPTION}
comandos:
   $(basename $0) -{command}
    h | help
    i | install
    r | remove
    up| update
    c | config
    t | template

    OBS: (-) ou (--) antes dos comandos é opcional
"

programa="$2"

url="https://raw.githubusercontent.com/tortoiselinux/scripts/main/src/$programa/$programa.sh"

diretorio_destino="$HOME/scripts/$programa"


case "$1" in
    "" | h |-h | help | --help)
        printf '%s\n' "$uso"
    ;;

    i | -i | install | --install)
        printf '%s\n' "iniciando instalação do programa..."

        printf '%s\n' "verificando se o diretório scripts existe..."

        if [ -d "$script_dir"  ]; then
            printf '%s\n' "diretório $script_dir existente."
        else
            printf '%s\n' "diretório não existente"

            exit 1
        fi

        printf '%s\n' "baixando código fonte..."

        if [ ! -d "$diretorio_destino"  ]; then
            mkdir -p "$diretorio_destino"

        fi
        
        wget -N -P "$diretorio_destino" "$url"

        ;;

    r | -r | remove | --remove)
        printf '%s\n' "removendo programas"
        rm -v "$diretorio_destino/$arquivo.sh"
    ;;

    up | -up | update | --update)
        printf "copiando código fonte..."
    ;;

    c | -c | config | --config)
        nano "$HOME/tegg/tegg.sh"
    ;;

    t | -t | template | --template)

        
        printf '%s\n' "verificando se o diretório scripts existe..."

        if [ -d "$script_dir"  ]; then
            printf '%s\n' "diretório $script_dir existente."
        fi

        printf '%s\n' "verificando estruturas de pastas..."

        if [ -d "$src_dir"  ]; then
            printf '%s\n' "diretório $src_dir existente."
        fi

        if [ -d "$links_dir"  ]; then
            printf '%s\n' "diretório $links_dir existente."
        fi

        printf '%s\n' "verificando se os programas estão carregados no path..."

        if [ grep -q "export PATH=$PATH:/.turtle" "$HOME/.bash_profile"  ]; then
            printf '%s\n' "programas carregados."
        fi

        printf '%s\n' "gerando diretório principal do programa"
        mkdir "$2"

        printf '%s\n' "adentrando no oceano!"
        cd "$HOME/scripts/src/$2"
        printf '%s\n' "criando modelo..."
        mkfile -s "$2".sh
        printf '%s\n' "gerando changelogs..."
        mkfile -e CHANGELOG.TXT
        printf '%s\n' "gerando symlinks para o script..."
        ln "$HOME/scripts/src/$2" -t "$HOME/scripts/symlinks"
    ;;

    *)
        printf "opção inválida digite (-h) para mais informações"
        exit 1
    ;;
esac