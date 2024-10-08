# Integração com SGP e IXCSoft

Este repositório contém as integrações com os sistemas SGP e IXCSoft, além de suporte a configurações com Asterisk. Abaixo, você encontrará as instruções para clonar o repositório, acessar as integrações e configurar as variáveis de ambiente.

## Clonando o Repositório

Para clonar o repositório, use o comando abaixo:

```bash
git clone https://github.com/phonevox/qint
```

## Acessando o Diretório do Projeto
Após a clonagem, navegue até o diretório do projeto com:

```bash
cd qint
```

## Escolhendo a Integração
O repositório possui diferentes integrações. Acesse a integração desejada com um dos seguintes comandos:

### Para a integração com SGP:
```bash
cd sgp
```

### Ou, para a integração com IXC:
```bash
cd ixc
```

Siga os passos descritos no arquivo `steps.md` dentro do diretório correspondente à integração escolhida.

Depois de configurar as variáveis de ambiente, você pode executar o script de instalação com o seguinte comando:
```bash
./install.sh < <nome_do_arquivo_de_configuracao>
```