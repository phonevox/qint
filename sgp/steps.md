# Configurações de Integração com SGP e Asterisk

Este documento descreve as variáveis de ambiente e diretórios necessários para a configuração da integração com o sistema SGP e o Asterisk.

## Variáveis de Integração

### Tipo de Integração
- `TIPO_INTEGRACAO`: Define o tipo de integração utilizado. Exemplo: `sgp`

### Configurações SCP
- `SCP_USER`: Usuário utilizado para conexão SCP.
- `SCP_HOST_REMOTO`: Endereço do host remoto para a conexão SCP.
- `SCP_VERSAO_INTEGRACAO`: Versão da integração que está sendo utilizada.
- `SCP_DESTINO_PULL`: Destino onde os arquivos SCP serão armazenados. Default: `.` (diretório atual).

## Diretórios do Asterisk

- `DIR_ASTERISK_AGI`: Diretório onde estão localizados os scripts AGI do Asterisk. Default: `/var/lib/asterisk/agi-bin`
- `DIR_ASTERISK_EXTENSIONS`: Diretório onde ficam as extensões do Asterisk. Default: `/etc/asterisk`
- `DIR_ASTERISK_PHP`: Diretório onde ficam os arquivos PHP do sistema HTML. Default: `/var/www/html`
- `DIR_ASTERISK_SOUNDS`: Diretório onde ficam os arquivos de áudio do Asterisk. Default: `/var/lib/asterisk/sounds`
- `DIR_ASTERISK_MUSICONHOLD`: Diretório onde ficam os arquivos de música de espera (MusicOnHold). Default: `/var/lib/asterisk/moh`

## Configurações de Time Condition

- `ID_TIMECONDITION_EXITPOINT`: ID que define o ponto de saída de uma condição de tempo no sistema.

## Configurações do Servidor

- `PROTOCOLO_WEB`: Protocolo utilizado pelo servidor web (http ou https).
- `PORTA_WEB`: Porta na qual o servidor web está operando.
- `IP_HOST`: Endereço IP do servidor host.
- `TOKEN`: Token de autenticação para acesso ao sistema.
- `APP`: Nome da aplicação.
- `URL_PBX`: URL do PABX para registro de gravações no SGP. Exemplo de configuração: `https://sip.helpvoxcc.com.br/get_recording.php?callid=${TOUCH_MONITOR}`

## Configurações Setoriais

As variáveis a seguir são utilizadas para configurar as filas, setores e motivos de ordem de serviço (OS) em diferentes departamentos:

### Geral
- `FILA_GERAL`: Número da fila para o setor geral.
- `ID_SETOR_GERAL`: ID que define o departamento geral.
- `ID_OCORRENCIA_GERAL`: ID que define o tipo de ocorrência geral.
- `ID_MOTIVO_OS_GERAL`: ID que define o motivo da OS (Ordem de Serviço) para o setor geral.

### Comercial
- `FILA_COMERCIAL`: Número da fila para o setor comercial.
- `ID_SETOR_COMERCIAL`: ID que define o departamento comercial.
- `ID_OCORRENCIA_COMERCIAL`: ID que define o tipo de ocorrência comercial.
- `ID_MOTIVO_OS_COMERCIAL`: ID que define o motivo da OS para o setor comercial.

### Suporte
- `FILA_SUPORTE`: Número da fila para o setor de suporte.
- `ID_SETOR_SUPORTE`: ID que define o departamento de suporte.
- `ID_OCORRENCIA_SUPORTE`: ID que define o tipo de ocorrência no suporte.
- `ID_MOTIVO_OS_SUPORTE`: ID que define o motivo da OS para o setor de suporte.

### Financeiro
- `FILA_FINANCEIRO`: Número da fila para o setor financeiro.
- `ID_SETOR_FINANCEIRO`: ID que define o departamento financeiro.
- `ID_OCORRENCIA_FINANCEIRO`: ID que define o tipo de ocorrência financeira.
- `ID_MOTIVO_OS_FINANCEIRO`: ID que define o motivo da OS para o setor financeiro.