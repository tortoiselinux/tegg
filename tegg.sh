#!/usr/bin/env bash
#========================{CABEÇALHO}=======================|                                                    #
#AUTOR:
#   wellyton 'welly' <welly.tohn@gmail.com>             #
#NOME: tegg.sh
#
#
#DESCRIÇÃO:                                             #   esse é o gerenciador e instalador de programas e scripts
#   tegg! O dever desse programa é baixar e atualizar cada um
#   dos scripts necessários e suas dependências.
#   Além disso, ele dá suporte aos desenvolvedores, gerando
#   templates para que crie os seus próprios no padrão do projeto
#   tortoise!                                           #
#LICENÇA:                                               #   MIT
#
#CHANGELOG:
#   VERSÃO 0.0.1 - BETA
#                                                       #   Descrição:
#       versão inicial
#   Alterações:
#       - criado funções básicas (instalar, remover, atualizar - ainda não funcional, configurar)
#       - criado função de template
#
#   VERSÃO 0.0.2 - BETA
#
#   Descrição:
#       problema de arquivo e diretórios vindo vazios resolvidos
#
#   Alterações:
#       - erros no código corrigidos
#       - curl substituído por wget
#
#   VERSÃO 0.0.3 - BETA
#
#   Descrição:
#       - essa versão automatiza a geração da estrutura de diretórios necessária.
#
#   Alterações:
#       - caminhos para programas corrigido
#       - verificação de diretórios no momento da instalação
#       - geração automatizada de diretórios essenciais.
#       - caminho do fonte para opção config corrigido.
#       - remoção de programas corrigida
#       - geração automática de links simbólicos
#       - remoção de links simbólicos adicionada a opção remove
#

# VARIAVEIS GLOBAIS

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

script_dir="$HOME/scripts"
src_dir="$HOME/scripts/src"
links_dir="$HOME/scripts/symlinks"


programa="$2"

url="https://raw.githubusercontent.com/tortoiselinux/scripts/main/src/$programa/$programa.sh"

diretorio_destino="$HOME/scripts/src/$programa"

case "$1" in
    "" | h |-h | help | --help)
        printf '%s\n' "$uso"
    ;;

    i | -i | install | --install)
        printf '%s\n' "iniciando instalação do programa..."

        printf '%s\n' "verificando se o diretório scripts existe..."

        if [ ! -d "$script_dir"  ]; then

            printf '%s\n' "diretório não existente"
            printf '%s\n' "criando diretorio."
            mkdir -p "$script_dir"

        else

            printf '%s\n' "diretório $script_dir existente."

        fi

        printf '%s\n' "verificando se o diretório scripts existe."

        if [ ! -d "$src_dir"  ]; then

            printf '%s\n' "diretorio não existe"
            printf '%s\n' "criando diretorio $src_dir"
            mkdir -p "$src_dir"

        else

           printf '%s\n' "diretorio $src_dir existe"

        fi

        printf '%s\n' "verificando se o diretório symlinks existe"

        if [ ! -d "$links_dir"  ]; then

            printf '%s\n' "gerando diretorio $links_dir"
            mkdir -p "$links_dir"

        else

            printf '%s\n' "$links_dir existe."

        fi

        if [ ! -d "$diretorio_destino"  ]; then

            printf '%s\n' "gerando diretorio de destino"
            mkdir -p "$diretorio_destino"

        else

            printf '%s\n' "$diretorio_destino existe."

        fi

        printf '%s\n' "baixando código fonte..."

        wget -N -P "$diretorio_destino" "$url"

        printf '%s\n' "concedendo permissão de execução ao programa"

        chmod +x "$diretorio_destino/$programa.sh"

        printf '%s\n' "gerando link simbólico"

        ln -s "$diretorio_destino/$programa.sh" "$links_dir/$programa"
    ;;

    r | -r | remove | --remove)

        printf '%s\n' "removendo programas"
        rm -vrf "$diretorio_destino"

        printf '%s\n' "removendo links simbólicos"
        rm -v "$links_dir/$programa"

    ;;

    up | -up | update | --update)

        printf "copiando código fonte..."

    ;;

    c | -c | config | --config)

        nano -m "$src_dir/tegg/tegg"

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
