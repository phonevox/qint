# Configurações de Integração com IXCSoft e Asterisk

Este documento descreve as variáveis de ambiente e diretórios necessários para a configuração da integração com o sistema IXCSoft e o Asterisk.

## Variáveis de Integração

### Tipo de Integração
- `TIPO_INTEGRACAO`: Define o tipo de integração utilizado. Exemplo: `ixcsoft`

### Configurações SCP
- `SCP_USER`: Usuário utilizado para conexão SCP. Exemplo: `root`
- `SCP_PATH_TO_TYPE`: Caminho onde se encontram as pastas de integração no servidor. Default: `/etc/scp_folder/integracoes`
- `SCP_HOST_REMOTO`: Endereço do host remoto onde ficam os arquivos de integração originais.
- `SCP_VERSAO_INTEGRACAO`: Versão da integração. Exemplo: `/etc/scp_folder/integracoes/{tipo}/{versao}`
- `SCP_DESTINO_PULL`: Diretório de destino onde as pastas base da integração serão copiadas no servidor local. Default: `.` (diretório atual). Será criado o caminho `/versions/<tipoDaIntegracao>/<versaoIntegracao>/`.

## Diretórios do Asterisk

- `DIR_ASTERISK_AGI`: Diretório onde estão localizados os scripts AGI do Asterisk. Default: `/var/lib/asterisk/agi-bin`
- `DIR_ASTERISK_EXTENSIONS`: Diretório onde ficam as extensões do Asterisk. Default: `/etc/asterisk`
- `DIR_ASTERISK_PHP`: Diretório onde ficam os arquivos PHP do sistema HTML. Default: `/var/www/html`
- `DIR_ASTERISK_SOUNDS`: Diretório onde ficam os arquivos de áudio do Asterisk. Default: `/var/lib/asterisk/sounds`
- `DIR_ASTERISK_MUSICONHOLD`: Diretório onde ficam os arquivos de música de espera (MusicOnHold). Default: `/var/lib/asterisk/moh`

## Configurações de Time Condition

- `ID_TIMECONDITION_EXITPOINT`: ID da condição de tempo pela qual o atendimento sairá após passar por todo o fluxo. Usado, por exemplo, para verificar feriados.

## Parâmetros Específicos para ERP IXCSoft

As variáveis a seguir são utilizadas para configurar o sistema ERP IXCSoft:

### Servidor

- `IP_HOST`: Endereço IP do servidor.
- `PORTA_WEB`: Porta na qual o servidor web está operando.
- `PROTOCOLO_WEB`: Protocolo utilizado pelo servidor web (http ou https).
- `TOKEN`: Token de autenticação para o sistema.
- `ID_FILIAL`: ID da filial utilizada no ERP. Padrão: `1`.

### Configurações Setoriais

As variáveis abaixo são utilizadas para configurar filas e departamentos de atendimento no sistema IXCSoft:

#### Geral
- `FILA_GERAL`: Número da fila para o atendimento geral.
- `ID_DEPARTAMENTO_GERAL`: ID que define o departamento para o atendimento geral.
- `ID_ASSUNTO_GERAL`: ID que define o assunto para o atendimento geral.

#### Comercial
- `FILA_COMERCIAL`: Número da fila para o atendimento comercial.
- `ID_DEPARTAMENTO_COMERCIAL`: ID que define o departamento para o atendimento comercial.
- `ID_ASSUNTO_COMERCIAL`: ID que define o assunto para o atendimento comercial.

#### Suporte
- `FILA_SUPORTE`: Número da fila para o atendimento de suporte.
- `ID_DEPARTAMENTO_SUPORTE`: ID que define o departamento para o atendimento de suporte.
- `ID_ASSUNTO_SUPORTE`: ID que define o assunto para o atendimento de suporte.

#### Financeiro
- `FILA_FINANCEIRO`: Número da fila para o atendimento financeiro.
- `ID_DEPARTAMENTO_FINANCEIRO`: ID que define o departamento para o atendimento financeiro.
- `ID_ASSUNTO_FINANCEIRO`: ID que define o assunto para o atendimento financeiro.
