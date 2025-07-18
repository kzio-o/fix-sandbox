# Windows Dev & Sandbox Setup Script (`fix-sandbox`)

**Automated Windows development environment setup script for Windows 10/11, LTSC editions, and Windows Sandbox.**

[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-orange.svg)](https://www.microsoft.com/windows)
[![Sandbox Compatible](https://img.shields.io/badge/Windows%20Sandbox-Compatible-brightgreen.svg)](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview)

A fully automated PowerShell script designed to set up a complete Windows development environment from scratch. This script intelligently installs essential development tools including WinGet, Git, and Windows Terminal, while also adding Microsoft Store support to Windows LTSC editions. Perfect for new machine setup and instant Windows Sandbox environment provisioning.

---

## 🌐 Language / Idioma

- **English**: [Continue reading below](#-features)
- **Português**: [Versão em português](#-readme-em-português)

---

## ✨ Features

- **🤖 Fully Automated**: Zero user interaction required - run the script and let it handle everything
- **🔄 Idempotent & Safe**: Intelligently checks for existing installations and skips them safely
- **📦 Sandbox Ready**: Instantly provisions complete development environments in Windows Sandbox
- **🏪 LTSC Compatible**: Automatically installs Microsoft Store on LTSC editions
- **🧹 Self-Cleaning**: Uses temporary directories and cleans up after completion
- **⚡ Modern Tools**: Installs and configures the latest Windows Terminal

## 🎯 Target Audience

This script is designed for:

- **👨‍💻 Developers** setting up new development machines
- **🔧 IT Professionals** and **System Administrators** provisioning multiple workstations
- **🏢 Windows LTSC Users** requiring easy Microsoft Store installation
- **🧪 Windows Sandbox Users** creating disposable development environments

## 📋 Prerequisites

- Windows 10/11 (including LTSC editions)
- Administrator privileges
- PowerShell 5.1 or higher
- Internet connection

## 🚀 Quick Start

### Method 1: Interactive PowerShell (Recommended)

1. **Download the script**:
   ```powershell
   # Download setup.ps1 to your desired location
   ```

2. **Set execution policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
   ```

3. **Run the script**:  
  In the same Administrator PowerShell window, navigate to where you saved the file and run it:
   ```powershell
   # Navigate to script location
   cd C:\path\to\script
   
   # Execute the script
   .\setup.ps1
   ```

### Method 2: Direct Command Line

Run directly from Command Prompt (CMD) or Run dialog (`Win + R`) as Administrator:

```cmd
powershell -NoExit -ExecutionPolicy Bypass -File "C:\path\to\setup.ps1"
```

## 📦 Windows Sandbox Integration

### Prerequisites

Enable Windows Sandbox feature following the [official Microsoft documentation](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview).

### Automated Setup

Create a Windows Sandbox configuration file to automate the setup process:

#### Option A: Download Configuration File

1. Download `sandbox-config.wsb` from this repository
2. Place it in the same directory as `setup.ps1`
3. Double-click `sandbox-config.wsb` to launch

#### Option B: Manual Configuration

Create `sandbox-config.wsb` with the following content:

```xml
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>.</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop\SetupFiles</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>cmd.exe /c start "PowerShell" powershell.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\SetupFiles\setup.ps1"</Command>
  </LogonCommand>
</Configuration>
```

## 🔧 What the Script Does

The script performs the following operations in sequence:

1. **Administrative Privileges Check**: Verifies the script is running with Administrator rights
2. **WinGet Configuration**: Installs or repairs Windows Package Manager if needed
3. **Git Installation**: Installs Git for Windows using WinGet
4. **PATH Configuration**: Automatically adds Git to the user's PATH environment variable
5. **Microsoft Store Integration**: Installs Microsoft Store on LTSC editions
6. **System Locale Configuration**: Sets system locale to en-US (restart may be required)
7. **Store Cache Cleanup**: Clears Microsoft Store cache using `wsreset.exe`
8. **Windows Terminal Installation**: Installs the modern Windows Terminal
9. **Terminal Launch**: Opens Windows Terminal to indicate successful completion

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🐛 Issues

If you encounter any issues, please report them on the [Issues](../../issues) page.

---

## 🇧🇷 README em Português

**Script automatizado para configuração de ambiente de desenvolvimento Windows 10/11, edições LTSC e Windows Sandbox.**

Um script PowerShell totalmente automatizado projetado para configurar um ambiente de desenvolvimento Windows completo do zero. Este script instala de forma inteligente ferramentas essenciais de desenvolvimento, incluindo WinGet, Git e Windows Terminal, além de adicionar suporte à Microsoft Store em edições LTSC do Windows. Perfeito para configuração de novas máquinas e provisionamento instantâneo de ambientes no Windows Sandbox.

### ✨ Funcionalidades

- **🤖 Totalmente Automatizado**: Zero interação do usuário - execute o script e deixe-o cuidar de tudo
- **🔄 Idempotente e Seguro**: Verifica inteligentemente instalações existentes e as ignora com segurança
- **📦 Pronto para Sandbox**: Provisiona instantaneamente ambientes de desenvolvimento completos no Windows Sandbox
- **🏪 Compatível com LTSC**: Instala automaticamente a Microsoft Store em edições LTSC
- **🧹 Auto-limpeza**: Usa diretórios temporários e limpa após a conclusão
- **⚡ Ferramentas Modernas**: Instala e configura o Windows Terminal mais recente

### 🎯 Público-Alvo

Este script foi desenvolvido para:

- **👨‍💻 Desenvolvedores** configurando novas máquinas de desenvolvimento
- **🔧 Profissionais de TI** e **Administradores de Sistema** provisionando múltiplas estações de trabalho
- **🏢 Usuários do Windows LTSC** que precisam de instalação fácil da Microsoft Store
- **🧪 Usuários do Windows Sandbox** criando ambientes de desenvolvimento descartáveis

### 📋 Pré-requisitos

- Windows 10/11 (incluindo edições LTSC)
- Privilégios de Administrador
- PowerShell 5.1 ou superior
- Conexão com a Internet

### 🚀 Início Rápido

#### Método 1: PowerShell Interativo (Recomendado)

1. **Baixe o script**:
   ```powershell
   # Baixe setup.ps1 para o local desejado
   ```

2. **Configure a política de execução**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
   ```

3. **Execute o script**:
   Na mesma janela do PowerShell de Administrador, navegue até onde você salvou o arquivo e execute-o:
   ```powershell
   # Navegue até o local do script
   cd C:\caminho\para\script
   
   # Execute o script
   .\setup.ps1
   ```

#### Método 2: Linha de Comando Direta

Execute diretamente do Prompt de Comando (CMD) ou diálogo Executar (`Win + R`) como Administrador:

```cmd
powershell -NoExit -ExecutionPolicy Bypass -File "C:\caminho\para\setup.ps1"
```

### 📦 Integração com Windows Sandbox

#### Pré-requisitos

Habilite o recurso Windows Sandbox seguindo a [documentação oficial da Microsoft](https://docs.microsoft.com/pt-br/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview).

#### Configuração Automatizada

Crie um arquivo de configuração do Windows Sandbox para automatizar o processo de setup:

##### Opção A: Baixar Arquivo de Configuração

1. Baixe `sandbox-config.wsb` deste repositório
2. Coloque-o no mesmo diretório que `setup.ps1`
3. Dê um duplo clique em `sandbox-config.wsb` para iniciar

##### Opção B: Configuração Manual

Crie `sandbox-config.wsb` com o seguinte conteúdo:

```xml
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>.</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop\SetupFiles</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>cmd.exe /c start "PowerShell" powershell.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\SetupFiles\setup.ps1"</Command>
  </LogonCommand>
</Configuration>
```

### 🔧 O Que o Script Faz

O script executa as seguintes operações em sequência:

1. **Verificação de Privilégios Administrativos**: Verifica se o script está sendo executado com direitos de Administrador
2. **Configuração do WinGet**: Instala ou repara o Windows Package Manager se necessário
3. **Instalação do Git**: Instala o Git for Windows usando o WinGet
4. **Configuração do PATH**: Adiciona automaticamente o Git à variável de ambiente PATH do usuário
5. **Integração da Microsoft Store**: Instala a Microsoft Store em edições LTSC
6. **Configuração de Localidade do Sistema**: Define a localidade do sistema para en-US (reinicialização pode ser necessária)
7. **Limpeza do Cache da Store**: Limpa o cache da Microsoft Store usando `wsreset.exe`
8. **Instalação do Windows Terminal**: Instala o Windows Terminal moderno
9. **Inicialização do Terminal**: Abre o Windows Terminal para indicar conclusão bem-sucedida

### 📄 Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo [LICENSE](LICENSE) para detalhes.

### 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para enviar um Pull Request.

### 🐛 Problemas

Se você encontrar algum problema, por favor, reporte-os na página de [Issues](../../issues).
