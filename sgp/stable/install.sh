#!/usr/bin/bash

# -------------------------------------------------------------------------------- #
# // Utilitários

CURRDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$(colorir "amarelo")

colorir() {
  local cor=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  local texto=$2

  # Definir códigos de cores ANSI
  local cor_preto="\\\e[0;30m"
  local cor_vermelho="\\\e[0;31m"
  local cor_verde="\\\e[0;32m"
  local cor_amarelo="\\\e[0;33m"
  local cor_azul="\\\e[0;34m"
  local cor_magenta="\\\e[0;35m"
  local cor_ciano="\\\e[0;36m"
  local cor_branco="\\\e[0;37m"
  local cor_preto_claro="\\\e[1;30m"
  local cor_vermelho_claro="\\\e[1;31m"
  local cor_verde_claro="\\\e[1;32m"
  local cor_amarelo_claro="\\\e[1;33m"
  local cor_azul_claro="\\\e[1;34m"
  local cor_magenta_claro="\\\e[1;35m"
  local cor_ciano_claro="\\\e[1;36m"
  local cor_branco_claro="\\\e[1;37m"
  local cor_reset="\\\e[0m"

  # Verificar a cor selecionada e atribuir o código ANSI correspondente
  case "$cor" in
    "preto")
      cor_ansi=$cor_preto
      ;;
    "vermelho")
      cor_ansi=$cor_vermelho
      ;;
    "verde")
      cor_ansi=$cor_verde
      ;;
    "amarelo")
      cor_ansi=$cor_amarelo
      ;;
    "azul")
      cor_ansi=$cor_azul
      ;;
    "magenta")
      cor_ansi=$cor_magenta
      ;;
    "ciano")
      cor_ansi=$cor_ciano
      ;;
    "branco")
      cor_ansi=$cor_branco
      ;;
    "preto_claro")
      cor_ansi=$cor_preto_claro
      ;;
    "vermelho_claro")
      cor_ansi=$cor_vermelho_claro
      ;;
    "verde_claro")
      cor_ansi=$cor_verde_claro
      ;;
    "amarelo_claro")
      cor_ansi=$cor_amarelo_claro
      ;;
    "azul_claro")
      cor_ansi=$cor_azul_claro
      ;;
    "magenta_claro")
      cor_ansi=$cor_magenta_claro
      ;;
    "ciano_claro")
      cor_ansi=$cor_ciano_claro
      ;;
    "branco_claro")
      cor_ansi=$cor_branco_claro
      ;;
    *)
      cor_ansi=$cor_reset
      ;;
  esac

  # Imprimir o texto com a cor selecionada
  echo -e "${cor_ansi}${texto}${cor_reset}"
}

dExists() {
    # Checa se diretório existe. Retorna true/false.
    if [ -d "$1" ]; then
            echo true
    else
            echo false
    fi
}
fExists() {
    # Checa se file existe. Retorna true/false.
    if [ -f "$1" ]; then
            echo true
    else
            echo false
    fi
}

# / Aviso caso rode o script sem o parâmetro correto.
if [ -t 0 ]; then
    echo "Erro: Este script precisa ser iniciado com redirecionamento de entrada." >&2
    echo "Exemplo: sudo bash $0 < ARQUIVO_DE_PARAMETROS.txt" >&2
    exit 1
fi

# / Logs
mkdir -p ./logs/
LOGFILE="$(basename "$0" | cut -d. -f1)-$(date '+%Y-%m-%d').log" # nome-do-script-YYYY-MM-DD.log (nome do script sem a extensão dele (.sh))
if ! [ -f "./logs/$LOGFILE" ]; then # checa se o arquivo de log já existe
        echo -e "[$TIMESTAMP] Iniciando novo logfile" > ./logs/$LOGFILE
fi
root_log() {
echo -e "[$TIMESTAMP] $1" >> ./logs/$LOGFILE
echo -e "[$TIMESTAMP] $1"
}

# / Constantes
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S.%N')

# \\ FIM Utilitários

# // -------------------------------------------------------------------------------- //
# # Função responsável por obter os parâmetros a partir de um arquivo de entrada, definir as variáveis correspondentes e configurar os diretórios de integração.


obter_parametros () {

    log () {
        root_log "[$(colorir "ciano" "obter_parametros")] $1"
    }

    log "--- $(colorir "magenta_claro" "Parâmetros") ---"

    loop_le_arquivo_seta_parametros () {
        # Lê o arquivo inputtado, e seta os parametros. "Ignora" comentários e linhas vazias.

        while IFS='=' read -r parametro valor; do
            i=$(($i+1))
            # Se a linha não for VAZIA ( -n $parametro) e não iniciar com # ( ${parametro:0:1 != "#"} )
            if [[ -n $parametro && ${parametro:0:1} != "#" ]]; then
                # Tirando os comentários
                valor=$(echo "$valor" | cut -d "#" -f1 | sed 's/[[:space:]]*$//')

                log "[$(colorir "amarelo" "param")] $parametro=$valor"
                #eval "$parametro=\"$valor\""
                declare -g "$parametro=$valor"
            else
                log  "[DEBUG] Linha \"$i\" ignorada."
            fi
        done
    }
    loop_le_arquivo_seta_parametros 

    log "--- $(colorir "magenta_claro" "Local PATHs") ---"
    setando_diretorios_integracao () {

        # Não precisam ser preparadas (não vai verificar isso.)
        INTEGRACAO_DIR_VERSOES=$SCP_DESTINO_PULL/versions
        INTEGRACAO_DIR_TIPO_LOCAL=$INTEGRACAO_DIR_VERSOES/$TIPO_INTEGRACAO

        declarar_path() {
            # Declara o nome de uma variável ($1) e o caminho ($2), adicionando automaticamente na lista de checagens.

            local var_name=$1
            local var_value=$2

            # Expandir as variáveis no valor fornecido
            var_value=$(eval echo "$var_value")

            # Nota de log informando que a variável está sendo 'preparada'
            log "[$(colorir "amarelo" "Lpath")] Declarando caminho: $var_name=$var_value"

            # Setar a variável global com o nome e valor fornecidos
            declare -g "$var_name=$var_value"

            # Inserir o nome da variável na lista_vars_checagem
            lista_vars_checagem+=("$var_name")
        }

        declarar_path "INTEGRACAO_DIR_AGI" "$DIR_ASTERISK_AGI/$TIPO_INTEGRACAO"
        declarar_path "INTEGRACAO_DIR_EXTENSIONS" "$DIR_ASTERISK_EXTENSIONS/$TIPO_INTEGRACAO"
        declarar_path "INTEGRACAO_DIR_PHP" "$DIR_ASTERISK_PHP/$TIPO_INTEGRACAO"
        declarar_path "INTEGRACAO_DIR_SOUNDS" "$DIR_ASTERISK_SOUNDS/$TIPO_INTEGRACAO"
        declarar_path "INTEGRACAO_DIR_MOH" "$DIR_ASTERISK_MUSICONHOLD/$TIPO_INTEGRACAO"
        declarar_path "INTEGRACAO_DIR_VERSAO_LOCAL" "$INTEGRACAO_DIR_TIPO_LOCAL/$SCP_VERSAO_INTEGRACAO"

    }
    setando_diretorios_integracao
    
}


# // -------------------------------------------------------------------------------- //
# Verificando se há algum conflito com a estrutura atual no sistema, baseado nos arquivos que serão puxados.

verificar_possiveis_conflitos () {
    log () {
        root_log "[$(colorir "ciano" "verificar_possiveis_conflitos")] $1"
    }

    log "--- $(colorir "magenta_claro" "Conflitos") ---"

    # Listo as variáveis que vou testar.
    # Pra cada variável na lista
    for variavel in "${lista_vars_checagem[@]}"; do

        # Confiro se o diretório (ou seja, ela expandida) NÃO existe.
        if ! $(dExists "${!variavel}"); then

            # Se não existir (não há conflito nessa pasta), expando a variável e logo como $(colorir "verde" SUCCESS) > Deu certo.
            log "$(colorir "verde" SUCCESS) - ${!variavel}"

        else

            # Se existir (há um conflito, essa pasta que vai ser usada como destino JÁ existe no nosso sistema), expando a variável, logo como $(colorir "vermelho" "ERROR"), e declaro uma variável __FLAG_{variável}.
            log "$(colorir "vermelho" "ERROR")   - ${!variavel}"
            declare -g "__FLAG_$variavel=true"

        fi
    done

}

# // -------------------------------------------------------------------------------- //
# Confirmando, com o usuário que executou o script, algumas informações

confirmar_parametros () {
    log () {
        root_log "[$(colorir "ciano" "confirmar_parametros")] $1"
    }

    flag_test () {
        if [[ ${!1} = "true" ]]; then
            return 0  # Verdadeiro
        else
            return 1  # Falso
        fi
    }

    menu_sobrescrever_utilizar_abortar () {
        # A função menu_sobrescrever_utilizar_abortar exibe um menu para o usuário selecionar uma opção relacionada à flag $flag. O usuário escolhe entre sobrescrever, utilizar o que já está instalado ou abortar. A escolha do usuário é armazenada no array associativo opcoes_escolhidas com a chave igual ao valor de $flag.

        local flag=$1
        local diretorio=$2
        local escolha
        echo -e "# Escolha o que deve ocorrer com $(colorir "vermelho" "$diretorio") ($flag):"
        echo -e "# 1 - Sobrescrever"
        echo -e "# 2 - Utilizar o que já está instalado"
        echo -e "# 3 - Abortar"

        read -p "# Opção: " escolha < /dev/tty
        case "$escolha" in
            1)
                opcoes_escolhidas["$flag"]="sobrescrever"
                ;;
            2)
                opcoes_escolhidas["$flag"]="utilizar"
                ;;
            3)
                opcoes_escolhidas["$flag"]="abortar"
                ;;
            *)
                echo "# Opção inválida!"
                read -r # Limpa o buffer de entrada
                echo -e ""
                menu_sobrescrever_utilizar_abortar "$flag" "$diretorio"
                ;;
        esac
    }

    tratar_flag () {
        # A função tratar_flag recebe uma flag $flag e uma variável $variavel. Ela verifica se a flag é verdadeira usando a função flag_test. Se a flag for verdadeira, exibe uma mensagem de erro indicando que ocorreu um erro verificando o diretório $diretorio. Em seguida, chama a função menu_sobrescrever_utilizar_abortar para que o usuário escolha uma opção relacionada à flag. A opção escolhida pelo usuário é armazenada no array associativo opcoes_escolhidas com a chave igual ao valor de $variavel. Dependendo da opção escolhida, são executadas ações correspondentes, como sobrescrever o diretório ou utilizar o que já está instalado. Caso a flag seja falsa, é exibida uma mensagem de sucesso indicando que a flag foi processada com sucesso.

        local flag=$1
        local variavel=$2
        local diretorio=${!variavel}

        if flag_test "$flag"; then
            echo -e "$(colorir "vermelho" "ERROR")   - $flag"
            echo "# Ocorreu um erro verificando o diretório \"$diretorio\" -- Possivelmente já existe."
            menu_sobrescrever_utilizar_abortar "$variavel" "$diretorio"
            local opcao="${opcoes_escolhidas["$variavel"]}"
            case "$opcao" in
                "sobrescrever")
                    echo -e "# Usuário escolheu $(colorir "amarelo" "sobrescrever") o diretório \"$diretorio\"."
                    ;;
                "utilizar")
                    echo -e "# Usuário escolheu $(colorir "amarelo" "utilizar") o diretório \"$diretorio\" já instalado."
                    echo -e "\n\n$(colorir "vermelho" "ESTA OPÇÃO NÃO ESTÁ IMPLEMENTADA!")\n\n"
                    exit 1
                    ;;
                *)
                    echo -e "# Usuário escolheu $(colorir "amarelo" "abortar")."
                    exit 1
                    ;;
            esac
        else
            echo -e "$(colorir "verde" SUCCESS) - $flag"
        fi
    }

    declare -gA opcoes_escolhidas

    # Array com as flags e variáveis correspondentes
    flags=(
    "__FLAG_INTEGRACAO_DIR_AGI:INTEGRACAO_DIR_AGI"
    "__FLAG_INTEGRACAO_DIR_EXTENSIONS:INTEGRACAO_DIR_EXTENSIONS"
    "__FLAG_INTEGRACAO_DIR_PHP:INTEGRACAO_DIR_PHP"
    "__FLAG_INTEGRACAO_DIR_SOUNDS:INTEGRACAO_DIR_SOUNDS"
    "__FLAG_INTEGRACAO_DIR_MOH:INTEGRACAO_DIR_MOH"
    "__FLAG_INTEGRACAO_DIR_VERSAO_LOCAL:INTEGRACAO_DIR_VERSAO_LOCAL"
    # Adicione outras flags e variáveis aqui
    )

    # Itera sobre as flags e chama a função tratar_flag para cada uma
    for flag_var in "${flags[@]}"; do
    IFS=':' read -r flag variavel <<< "$flag_var"
    tratar_flag "$flag" "$variavel"
    done

}



# // -------------------------------------------------------------------------------- //
# Puxando, de fato, os arquivos da integração.

puxar_arquivos_integracao () {
    log () {
        root_log "[$(colorir "ciano" "puxar_arquivos_integracao")] $1"
    }

    mkdir_dir_tipo_local () {
        checa_erro_mkdir () {
            if [[ $mkdir_status -ne 0 ]]; then
                log "[$(colorir "amarelo" "MKDIR/TIPO_LOCAL")] $(colorir "vermelho" "ERROR") - Ocorreu algum erro ao tentar criar a pasta-destino pros arquivos da integração (\"$INTEGRACAO_DIR_TIPO_LOCAL\") (status:$mkdir_status)"
                exit 1
            else
                log "[$(colorir "amarelo" "MKDIR/TIPO_LOCAL")] $(colorir "verde" SUCCESS - \"mkdir -p $INTEGRACAO_DIR_TIPO_LOCAL\")"
            fi
        }

        log "[$(colorir "amarelo" "MKDIR/TIPO_LOCAL")] Criando, caso não exista, a pasta-raiz, destino do SCP: \"$INTEGRACAO_DIR_TIPO_LOCAL\""
        mkdir -p $INTEGRACAO_DIR_TIPO_LOCAL || local mkdir_status=$? # (tenta) Criar a pasta.
        checa_erro_mkdir # Verifica se falhou ou não.
        log "[$(colorir "amarelo" "MKDIR/TIPO_LOCAL")] Finalizado."

    }

    mkdir_dir_tipo_local # Cria o diretorio ./versions/{tipo}, e automaticamente verifica se deu algum erro nesse comando.

    realiza_scp () {
        checa_erro_scp () {
            if [[ $status -ne 0 ]]; then
                log "[$(colorir "amarelo" "SCP")] $(colorir "vermelho" "ERROR") - Ocorreu algum erro ao tentar puxar os arquivos do host remoto. (status:$status) (host:$SCP_HOST_REMOTO)"
                echo -e "\n\nVerifique se o $(colorir "vermelho" "diretório que está tentando puxar"), está correto; pode ser um dos problemas. (NÃO É CERTEZA!)\n\n"
                exit 1
            fi
        }


        log "[$(colorir "amarelo" "SCP")] Puxando \"$(colorir "magenta_claro" "remote:/etc/scp_folder/integracoes/$TIPO_INTEGRACAO/$SCP_VERSAO_INTEGRACAO")\" -> \"$(colorir "magenta_claro" "local:$INTEGRACAO_DIR_TIPO_LOCAL")\""
        echo -e "\n\n< $(colorir "ciano_claro" "Logue-se no HOST REMOTO ! [$SCP_USER@$SCP_HOST_REMOTO]") >\n\n"

         # "-r" /etc/scp_folder/integracoes/sgp/v1-stable -> /etc/integrador/versions = /etc/integrador/versions/v1-stable
        scp -r $SCP_USER@$SCP_HOST_REMOTO:/etc/scp_folder/integracoes/$TIPO_INTEGRACAO/$SCP_VERSAO_INTEGRACAO $INTEGRACAO_DIR_TIPO_LOCAL || local status=$? # EU NÃO VOU AUTOMATIZAR O PROCESSO DE REPASSAR À SENHA AO SCP. ISSO É EXTREMAMENTE INSEGURO.
        checa_erro_scp # Verifica se falhou ou não.
        log "[$(colorir "amarelo" "SCP")] $(colorir "verde" "SUCCESS") - Integração obtida com sucesso"
    }

    realiza_scp # Realiza, de fato, o SCP, e informa caso der erro ou não.

}

# // -------------------------------------------------------------------------------- //
# Puxando, de fato, os arquivos da integração.

alterando_parametros () {
    log () {
        root_log "[$(colorir "ciano" "alterando_parametros")] $1"
    }

    parametros_php () {

        local LOCAL_PHP_CONFIG=$INTEGRACAO_DIR_VERSAO_LOCAL/files/php/$TIPO_INTEGRACAO/config.php

        log "[$(colorir "amarelo" "PHP")] \$server_local = $URL_PBX"
        sed -i "s|\$server_local = ''|\$server_local = '$URL_PBX'|" $LOCAL_PHP_CONFIG || { log "sed \"\$server_local\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] \$protocol_web = $PROTOCOLO_WEB"
        sed -i "s|\$protocol_web = ''|\$protocol_web = '$PROTOCOLO_WEB'|" $LOCAL_PHP_CONFIG || { log "sed \"\$protocol_web\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] \$servidor_web = $IP_HOST"
        sed -i "s|\$servidor_web = ''|\$servidor_web = '$IP_HOST'|" $LOCAL_PHP_CONFIG || { log "sed \"\$servidor_web\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] \$porta_web = $PORTA_WEB"
        sed -i "s|\$porta_web = ''|\$porta_web = '$PORTA_WEB'|" $LOCAL_PHP_CONFIG || { log "sed \"\$porta_web\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] \$token = $TOKEN"
        sed -i "s|\$token = ''|\$token = '$TOKEN'|" $LOCAL_PHP_CONFIG || { log "sed \"\$token\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] \$app = $APP"
        sed -i "s|\$app = ''|\$app = '$APP'|" $LOCAL_PHP_CONFIG || { log "sed \"\$app\" falhou."; exit 1; }

        log "[$(colorir "amarelo" "PHP")] $(colorir "verde" SUCCESS) - Alterações concluidas em $LOCAL_PHP_CONFIG"
    }

    parametros_macro () {

        local LOCAL_MACROS_CONF=$INTEGRACAO_DIR_VERSAO_LOCAL/files/exten/$TIPO_INTEGRACAO/phonevox-macros-atendimento.conf

        # Função genérica para substituir valor em um arquivo e tratar erros
        substituir_valor() {
            local arquivo="$1"
            local valor_antigo="$2"
            local valor_novo="$3"

            log "[$(colorir "amarelo" "MACRO")] $valor_novo"
            sed -i "s|${valor_antigo}|${valor_novo}|" "$arquivo" || { log "sed \"$valor_novo\" falhou."; exit 1; }
        }

        # Chamar a função para substituir os valores específicos

        # FILAS
        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(dep_outros_assuntos=XXX)" \
        "Set(dep_outros_assuntos=$FILA_GERAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(dep_comercial=XXX)" \
        "Set(dep_comercial=$FILA_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(dep_suporte=XXX)" \
        "Set(dep_suporte=$FILA_SUPORTE)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(dep_financeiro=XXX)" \
        "Set(dep_financeiro=$FILA_FINANCEIRO)"

        # ASSUNTOS
        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_outros_assuntos=XXX)" \
        "Set(ocorrencia_outros_assuntos=$ID_OCORRENCIA_GERAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_comercial=XXX)" \
        "Set(ocorrencia_comercial=$ID_OCORRENCIA_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_comercial_adesao=XXX)" \
        "Set(ocorrencia_comercial_adesao=$ID_OCORRENCIA_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_comercial_cancelamento=XXX)" \
        "Set(ocorrencia_comercial_cancelamento=$ID_OCORRENCIA_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_suporte=XXX)" \
        "Set(ocorrencia_suporte=$ID_OCORRENCIA_SUPORTE)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_financeiro=XXX)" \
        "Set(ocorrencia_financeiro=$ID_OCORRENCIA_FINANCEIRO)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_financeiro_simples=XXX)" \
        "Set(ocorrencia_financeiro_simples=$ID_OCORRENCIA_FINANCEIRO)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(ocorrencia_financeiro_bloqueio=XXX)" \
        "Set(ocorrencia_financeiro_bloqueio=$ID_OCORRENCIA_FINANCEIRO)"

        # ASSUNTOS O.S.
        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_outros_assuntos=XXX)" \
        "Set(motivoos_outros_assuntos=$ID_MOTIVO_OS_GERAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_comercial_adesao=XXX)" \
        "Set(motivoos_comercial_adesao=$ID_MOTIVO_OS_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_comercial_cancelamento=XXX)" \
        "Set(motivoos_comercial_cancelamento=$ID_MOTIVO_OS_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_suporte=XXX)" \
        "Set(motivoos_suporte=$ID_MOTIVO_OS_SUPORTE)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_financeiro_simples=XXX)" \
        "Set(motivoos_financeiro_simples=$ID_MOTIVO_OS_FINANCEIRO)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(motivoos_financeiro_bloqueio=XXX)" \
        "Set(motivoos_financeiro_bloqueio=$ID_MOTIVO_OS_FINANCEIRO)"

        # SETORES/DEPARTAMENTOS
        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(setor_outros_assuntos=XXX)" \
        "Set(setor_outros_assuntos=$ID_SETOR_GERAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(setor_comercial=XXX)" \
        "Set(setor_comercial=$ID_SETOR_COMERCIAL)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(setor_suporte=XXX)" \
        "Set(setor_suporte=$ID_SETOR_SUPORTE)"

        substituir_valor "$LOCAL_MACROS_CONF" \
        "Set(setor_financeiro=XXX)" \
        "Set(setor_financeiro=$ID_SETOR_FINANCEIRO)"

        # FINAL/DESTINOS
        substituir_valor "$LOCAL_MACROS_CONF" \
        "Goto(timeconditions,TIMECONDITION_DESTINO,1)" \
        "Goto(timeconditions,$ID_TIMECONDITION_EXITPOINT,1)"
        
        log "[$(colorir "amarelo" "MACRO")] $(colorir "verde" SUCCESS) - Alterações concluidas em $LOCAL_MACROS_CONF"
    }

    log "--- $(colorir "magenta_claro" "PHP") ---"
    parametros_php

    log "--- $(colorir "magenta_claro" "Macro") ---"
    parametros_macro

}


# // -------------------------------------------------------------------------------- //
# Editando, se necessário, as permissões dos arquivos da integração.

editar_permissoes() {
    log () {
        root_log "[$(colorir "ciano" "editar_permissoes")] $1"
    }


    # Função para atualizar as permissões de um diretório
    atualizar_permissoes() {
        local diretorio=$1
        log "[$(colorir "amarelo" "PERM.")] Atualizando permissões do diretório: $diretorio"
        chmod -R 755 "$diretorio" || permission_status=$?
        if [[ $permission_status -ne 0 ]]; then
            log "[$(colorir "amarelo" "PERM.")] $(colorir "vermelho" "ERRO") - Ocorreu um erro ao tentar alterar as permissões do diretório: $diretorio"
            exit 1
        else
            log "[$(colorir "amarelo" "PERM.")] $(colorir "verde" "SUCCESS") - Permissões atualizadas para 755: $(colorir "amarelo" "$diretorio")"
        fi
    }

    # Função para atualizar o proprietário de um diretório
    atualizar_proprietario() {
        local diretorio=$1
        log "[$(colorir "amarelo" "PROP.")] Atualizando proprietário do diretório: $diretorio"
        chown -R asterisk:asterisk "$diretorio" || proprietary_status=$?
        if [[ $proprietary_status -ne 0 ]]; then
            log "[$(colorir "amarelo" "PROP.")] $(colorir "vermelho" "ERRO") - Ocorreu um erro ao tentar alterar o proprietário do diretório: $diretorio"
            exit 1
        else
            log "[$(colorir "amarelo" "PROP.")] $(colorir "verde" "SUCCESS") - Proprietário atualizado para asterisk:asterisk: $diretorio"
        fi
    }

    # Path pro arquivo que define se deve ou não atualizar as perm.
    local require_info_path="$INTEGRACAO_DIR_VERSAO_LOCAL/files/agi/$TIPO_INTEGRACAO/require_info.php"

    # Verificar as permissões - chatgpt
    log "--- $(colorir "magenta_claro" "Permissão") ---"
    log "[$(colorir "amarelo" "PERM.")] Verificando se precisa atualizar as permissões do arquivo."
    if [[ $(stat -c "%a" "$require_info_path") != "755" ]]; then
        atualizar_permissoes "$INTEGRACAO_DIR_VERSAO_LOCAL/files/agi/"
        atualizar_permissoes "$INTEGRACAO_DIR_VERSAO_LOCAL/files/php/"
    fi
    log "[$(colorir "amarelo" "PERM.")] Verificação finalizada."

    # Verificar o proprietário - chat gpt
    log "--- $(colorir "magenta_claro" "Proprietário") ---"
    log "[$(colorir "amarelo" "PROP.")] Verificando se precisa atualizar o proprietário do arquivo."
    if [[ $(stat -c "%U:%G" "$require_info_path") != "asterisk:asterisk" ]]; then
        atualizar_proprietario "$INTEGRACAO_DIR_VERSAO_LOCAL/files/agi/"
    fi
    log "[$(colorir "amarelo" "PROP.")] Verificação finalizada."
}


# // -------------------------------------------------------------------------------- //
# Copiando os arquivos da pasta de versão LOCAL, para as pastas usadas pelo Asterisk

mover_arquivos () {
    log () {
        root_log "[$(colorir "ciano" "mover_arquivos")] $1"
    }

    # log "Movendo (copiando) os arquivos da versão local, até seus devidos destinos."

    mover () {
        cp -R "$1" "$2" || { log "[$(colorir "amarelo" "MV")] $(colorir "vermelho" "ERROR") - cp \"$1\" -> \"$2\" falhou."; exit 1; }
        log "[$(colorir "amarelo" "MV")] $(colorir "verde" "SUCCESS") - $1 -> $2"
    }

    # log "--- $(colorir "magenta_claro" "Arquivos") ---"
    # mover $INTEGRACAO_DIR_VERSAO_LOCAL/files/agi/* $DIR_ASTERISK_AGI
    # mover $INTEGRACAO_DIR_VERSAO_LOCAL/files/php/* $DIR_ASTERISK_PHP
    # mover $INTEGRACAO_DIR_VERSAO_LOCAL/files/exten/* $DIR_ASTERISK_EXTENSIONS

    # log "--- $(colorir "magenta_claro" "Áudios") ---"
    # mover $INTEGRACAO_DIR_VERSAO_LOCAL/moh/* $DIR_ASTERISK_MUSICONHOLD
    # mover $INTEGRACAO_DIR_VERSAO_LOCAL/audios/* $DIR_ASTERISK_SOUNDS

    mover_com_verificacao() {
    local origem="$(realpath "$1")"
    local destino="$(realpath "$2")"
    local flag="__FLAG_INTEGRACAO_DIR_$(basename "$destino" | tr '[:lower:]' '[:upper:]')"

    if [[ "${opcoes_escolhidas["$flag"]}" = "sobrescrever" ]]; then
        echo -e "\n\n\n$(colorir "vermelho" "O DIRETÓRIO \"$destino\" FOI DELETADO!")\n\n\n"
        rm -rf "$destino"/*
    fi

    cp -R "$origem"/* "$destino" || { log "[$(colorir "amarelo" "MV")] $(colorir "vermelho" "ERROR") - cp \"$origem\" -> \"$destino\" falhou."; exit 1; }
    log "[$(colorir "amarelo" "MV")] $(colorir "verde" "SUCCESS") - $origem -> $destino"
}

    log "--- $(colorir "magenta_claro" "Arquivos") ---"
    mover_com_verificacao "$INTEGRACAO_DIR_VERSAO_LOCAL/files/agi/" "$DIR_ASTERISK_AGI"
    mover_com_verificacao "$INTEGRACAO_DIR_VERSAO_LOCAL/files/php/" "$DIR_ASTERISK_PHP"
    mover_com_verificacao "$INTEGRACAO_DIR_VERSAO_LOCAL/files/exten/" "$DIR_ASTERISK_EXTENSIONS"

    log "--- $(colorir "magenta_claro" "Áudios") ---"
    mover_com_verificacao "$INTEGRACAO_DIR_VERSAO_LOCAL/moh/" "$DIR_ASTERISK_MUSICONHOLD"
    mover_com_verificacao "$INTEGRACAO_DIR_VERSAO_LOCAL/audios/" "$DIR_ASTERISK_SOUNDS"
}


# // -------------------------------------------------------------------------------- //
# Últimos toques, como dialplan reload e adição de conteúdo.

ajustes_finais () {
    log () {
        root_log "[$(colorir "ciano" "ajustes_finais")] $1"
    }

    local __NOME_ARQUIVO_INCLUDE=phonevox.conf # Qual o nome do arquivo que tá com os includes da integração?
    local __LINHA_DE_INCLUDE="#tryinclude $TIPO_INTEGRACAO/$__NOME_ARQUIVO_INCLUDE" # Qual o texto que deve ser inserido no extensions_custom.conf pra rodar o arquivo de include?
    local __PATH_FINAL_ARQUIVO_DE_EXTENSIONS=$DIR_ASTERISK_EXTENSIONS/extensions_custom.conf # Qual o arquivo que vai realizar a linha de include/ que vai receber a linha de include?
    local __PATH_FINAL_ARQUIVO_DE_MOH=$DIR_ASTERISK_EXTENSIONS/musiconhold_custom.conf
    local __LINHA_CLASS_MOH="[sfx-teclado-digitando]\nmode=files\ndirectory=$DIR_ASTERISK_MUSICONHOLD/$TIPO_INTEGRACAO/sfx-teclado-digitando"

    verificar_conteudo_arquivo() {
        # Roda uma única vez:
        #
        # if verificar_conteudo_arquivo "arquivo_teste" "texto"; then
        #   algo_verdadeiro
        # else
        #   algo_falso
        # fi
        local arquivo="$1"
        local conteudo="$2"

        if grep -qF "$conteudo" "$arquivo"; then
            return 0  # Verdadeiro
        else
            return 1  # Falso
        fi
    }

    verificar_linha_arquivo() {
        # Pode rodar, pacialmente, várias vezes:
        #
        # if verificar_linha_arquivo "arquivo_teste" "[sfx-teclado-digitando]" && \
        # verificar_linha_arquivo "arquivo_teste" "mode=files" && \
        # verificar_linha_arquivo "arquivo_teste" "directory=$DIR_ASTERISK_MUSICONHOLD/$TIPO_INTEGRACAO/sfx-teclado-digitando"; then
        #     algo_verdadeiro
        # else
        #     algo_falso
        # fi

        local arquivo="$1"
        local linha="$2"

        if grep -Fxq "$linha" "$arquivo"; then
            return 0  # Verdadeiro
        else
            return 1  # Falso
        fi
    }

    checar_include () {
        if verificar_conteudo_arquivo "$__PATH_FINAL_ARQUIVO_DE_EXTENSIONS" "$__LINHA_DE_INCLUDE"; then
            log "[$(colorir "amarelo" "ECHO/INCLUDE")] $(colorir "verde" "Include já existe")"
        else
            echo -e "$__LINHA_DE_INCLUDE" >> "$__PATH_FINAL_ARQUIVO_DE_EXTENSIONS"
            log "[$(colorir "amarelo" "ECHO/INCLUDE")] Include $(colorir "vermelho" "NÃO") existia; inserido."
        fi
    }
    
    checar_classe_moh_sfxteclado () {
        # Não vou verificar todas as linhas do arquivo, pois se o script determinar um path diferente, não vai bater. E duas classes com 2 diertórios diffs vai dar problema no Asterisk. (estou chutando ->) Como o que dá problema é ter duas classes repetidas, vou checar logo a classe, e se ela existir, uso ela mesmo.
        # Prevejo um futuro problema onde duas integrações precisem utilizar o áudio "sfx-teclado-digitando" mas o áudio tá sendo usado pelo outro tipo de integração. Para resolver isso, o aconselhavél seria alterar o nome da classe pra "[blablabla-$TIPO_INTEGRACAO]" e alterar a chamada à essa classe nos arquivos da Integração. 
        if verificar_conteudo_arquivo "$__PATH_FINAL_ARQUIVO_DE_MOH" "[sfx-teclado-digitando]"; then
            log "[$(colorir "amarelo" "ECHO/MOH_CLASS")] $(colorir "verde" "Classe \"sfx-teclado-digitando\" já existe.")"
        else
            echo -e "$__LINHA_CLASS_MOH" >> "$__PATH_FINAL_ARQUIVO_DE_MOH"
            log "[$(colorir "amarelo" "ECHO/MOH_CLASS")] Classe de MusicOnHold \"sfx-teclado-digitando\" $(colorir "vermelho" "NÃO") existia; inserido."
        fi
    }

    checar_include # Checa se o include já está presente, e caso não, insere.
    checar_classe_moh_sfxteclado # Checa se a classe sfx-teclado-digitando existe, e caso não, insere.

    log "Recarregando dialplan."
    asterisk -rx 'dialplan reload'

    orientacoes () {
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e "Crie as seguintes $(colorir "amarelo_claro" "custom destinations") no PABX:"
        echo -e ""
        echo -e "$(colorir "magenta" "inicio"),$(colorir "verde" "s"),$(colorir "magenta" "1")"
        echo -e "URA - SGP - INICIO"
        echo -e ""
        echo -e "$(colorir "magenta" "feriado"),$(colorir "verde" "s"),$(colorir "magenta" "1")"
        echo -e "URA - SGP - FERIADO"
        echo -e ""
        echo -e "$(colorir "magenta" "fechado"),$(colorir "verde" "s"),$(colorir "magenta" "1")"
        echo -e "URA - SGP - FECHADO"
        echo -e ""
        echo -e "$(colorir "magenta" "from-internal"),$(colorir "verde" "\${departamento}"),$(colorir "magenta" "1")"
        echo -e "URA - SGP - FILA"
        echo -e ""
        echo -e "Após, trate como preferir: o $(colorir "vermelho_claro" "ponto de saída") da URA vai bater na $(colorir "amarelo_claro" "Time Condition ID \"$ID_TIMECONDITION_EXITPOINT\"")"
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
        echo -e ""
    }

    orientacoes # Exibe as orientações sobre contexto

}






main () {

    # Obtenção e verificação dos parâmetros obtidos do arquivo.
    obter_parametros
    verificar_possiveis_conflitos
    confirmar_parametros

    # Puxando a integração em si.
    puxar_arquivos_integracao
    
    # Alterando os parâmetros e ajustando os arquivos antes de mover.
    alterando_parametros
    editar_permissoes

    # Movendo os arquivos, e aplicando.
    mover_arquivos
    ajustes_finais

}

clear
clear
main
