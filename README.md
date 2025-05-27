# |WSL 2 - Ubuntu e instalação do FASM (Linux 64x)

<aside>

## **|Começando**

## ✅ Pré-requisitos

## 🔧 Etapa 1: Ativar Recursos do Windows

1. Pressione `Win + R`, digite `optionalfeatures` e pressione Enter.
2. Ative:
    - **Subsistema do Windows para Linux**
    - **Plataforma de Máquina Virtual**
3. Clique em **OK** e **reinicie o computador**.
</aside>

---

---

## 🐚 Etapa 2: Instalar o WSL2 e Ubuntu

Abra o **PowerShell como Administrador**:

```powershell
wsl --install
```

Se estiver no **Windows 10** e o comando acima der erro, tente manualmente:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Reinicie o computador e instale o Ubuntu pela **Microsoft Store**:

[Ubuntu na Microsoft Store](https://apps.microsoft.com/store/search/ubuntu)

---

## 🧱 Etapa 3: Instalar o Windows Terminal

Instale o **Windows Terminal** pela Microsoft Store:

[Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701)

---

## 🛠️ Etapa 4: Instalar o Flat Assembler (FASM) no Ubuntu

Abra o Ubuntu no Windows Terminal e execute:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget tar build-essential -y
mkdir -p $HOME/fasm
cd $HOME/fasm
wget https://flatassembler.net/fasm-1.73.32.tgz
tar -xvzf fasm-1.73.32.tgz
cd fasm
chmod +x fasm
echo 'export PATH="$HOME/fasm/fasm:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Agora você pode usar o  `fasm` de qualquer lugar no terminal!

---

## 🧪 Etapa 5: Testar o FASM com "Hello, World"

Crie o arquivo:

```bash
nano hello.asm
```

Cole o seguinte código:

```nasm
format ELF64 executable
entry start

segment readable executable
start:
    mov     rax, 1          ; syscall number 1 = write
    mov     rdi, 1          ; file descriptor 1 = stdout
    mov     rsi, msg        ; mensagem
    mov     rdx, msg_len    ; tamanho da mensagem
    syscall                 ; chamada de sistema

    ; Encerrar o programa
    mov     rax, 60         ; syscall number 60 = exit
    xor     rdi, rdi        ; status 0
    syscall

segment readable writeable
msg     db 'Olá, Mundo!', 10
msg_len = $ - msg
```

Monte e execute:

```bash
fasm hello.asm
chmod +x hello
./hello
```

Você verá:

```bash
Hello, world!
```

---

## 📌 Dicas Finais

- O FASM funciona **apenas dentro do Ubuntu** (não no CMD ou PowerShell).
- Use sempre o **Windows Terminal** para melhor integração com o WSL.
- O Ubuntu pode ser definido como terminal padrão nas configurações do Windows Terminal.