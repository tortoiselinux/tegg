#!/usr/bin/env bash
#========================{CABEÇALHO}=======================|
#
#AUTOR:
#   wellyton 'welly' <welly.tohn@gmail.com>
#
#NOME: tegg
#
#VERSÃO: v0.0.6
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
#   VERSÃO 0.0.6 - BETA
#
#   Descrição:
#   - correção na função de configuração do tegg
#
#   Alterações:
#       - bug da função de configuração corrigido.
#   detalhes:
#       - a função de configuração tinha um erro no recebimento 
#       do argumento o que fazia que obtivesse sempre um argumento
#       vazio.

# VARIAVEIS GLOBAIS

uso="
$(basename $0) {OPTION}
comandos:
   $(basename $0) -{command}
    h | help
    i | install
    r | remove
    up | update
    c | config
    t | template

    OBS: (-) ou (--) antes dos comandos é opcional
"

script_dir="$HOME/scripts"
src_dir="$HOME/scripts/src"
links_dir="$HOME/scripts/symlinks"
programa="$2"
diretorio_destino="$HOME/scripts/src/$programa"
url="https://raw.githubusercontent.com/tortoiselinux/scripts/main/src/$programa/$programa.sh"

# FUNÇÕES
VERIFICA_DIR(){

	printf '%s\n' "verificando estruturas de pastas...."

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
}

VERIFICA_PATH(){

	printf '%s\n' "verificando se os programas estão carregados no path..."

	if grep -Fxq 'export "PATH=\$PATH:$HOME/scripts/symlinks"' "$HOME/.bashrc"; then

		printf '%s\n' "Programas já carregados no path."

	else

		echo 'export "PATH=\$PATH:$HOME/scripts/symlinks"' >> "$HOME/.bashrc"

		printf '%s\n' "Linha adicionada ao .bashrc"

	fi
}

VERIFICA_DESTINO(){

	 if [ ! -d "$diretorio_destino"  ]; then
	    printf '%s\n' "gerando diretorio de destino"

	    mkdir -p "$diretorio_destino"

	 else

	    printf '%s\n' "$diretorio_destino existe."

	 fi
}

# FUNCÕES DAS OPÇÕES

INSTALL(){

	printf '%s\n' "iniciando instalação do programa..."

	VERIFICA_DIR

	VERIFICA_DESTINO

    printf '%s\n' "baixando código fonte..."

    wget -N -P "$diretorio_destino" "$url"

    printf '%s\n' "concedendo permissão de execução ao programa"

    chmod +x "$diretorio_destino/$programa.sh"

    printf '%s\n' "gerando link simbólico"

    ln -s "$diretorio_destino/$programa.sh" "$links_dir/$programa"
}

REMOVE(){

	printf '%s\n' "removendo programas"

	rm -vrf "$diretorio_destino"

    printf '%s\n' "removendo links simbólicos"

    rm -v "$links_dir/$programa"

}

UPDATE(){
	url="https://raw.githubusercontent.com/tortoiselinux/tegg/main/tegg.sh"
	diretorio_destino="$HOME/scripts/src/tegg"
	programa="tegg"

	VERIFICA_DESTINO

	printf '%s\n' "baixando fonte..."
	wget -N -P "$diretorio_destino" "$url"

	printf '%s\n' "concedendo permissão de execução"
    chmod +x "$diretorio_destino/$programa.sh"

    printf '%s\n' "criando link simbólico"
	ln -s "$diretorio_destino/$programa.sh" "$links_dir/$programa"
}

CONFIG(){
	case "$1" in
	    "")

		  VERIFICA_DIR

		  VERIFICA_PATH
	    ;;

	    d | -d | dir | --dir)

		  VERIFICA_DIR
	    ;;

	    p | -p | path | --path)

		  VERIFICA_PATH
	    ;;

	    f | -f | font | --font)

		  nano -m -l "$links_dir/tegg"
	    ;;

        *)
            printf '%s\n' "não foi possível identificar o argumento."
        ;;
	esac
}

TEMPLATE(){

    printf '%s\n' "gerando diretório principal do programa"

    mkdir "$src_dir/$programa"

    printf '%s\n' "criando modelo..."

    mkfile -s "$diretorio_destino/$programa.sh"

    givePerms "$diretorio_destino/$programa.sh"

    printf '%s\n' "gerando changelogs..."

    mkfile -e "$diretorio_destino/CHANGELOG.txt"

    printf '%s\n' "gerando symlinks para o script..."

    ln -s "$diretorio_destino/$programa.sh" "$links_dir/$programa"
}

# INICIO

case "$1" in

    "" | h |-h | help | --help)

        printf '%s\n' "$uso"

    ;;

    i | -i | install | --install)

	   INSTALL

    ;;

    r | -r | remove | --remove)

	   REMOVE

    ;;

    up | -up | update | --update)

	   UPDATE

    ;;

    c | -c | config | --config)

	   CONFIG "$2"

    ;;

    t | -t | template | --template)

	   TEMPLATE

    ;;

    *)
        printf "opção inválida digite (-h) para mais informações"

        exit 1
    ;;

esac
