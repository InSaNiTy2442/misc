#!/bin/bash

log_info() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [info] $1"
}

log_warning() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [warning] $1"
}

log_error() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [error] $1"
}

log_info "Checking if PipeWire is already installed"

# Check if PipeWire is already installed
if dpkg-query -W -f='${Status}' "pipewire" 2>/dev/null | grep -q "ok installed"; then
    log_info "PipeWire is already installed"
    echo "Which audio system do you want to use with PipeWire?"
    options=("ALSA and JACK" "PulseAudio")
    select opt in "${options[@]}"
    do
        case $opt in
            "ALSA and JACK")
                log_info "Installing PipeWire modules for ALSA and JACK"
                sudo dnf install -y pipewire-alsa pipewire-jack-audio-connection-kit
                if [ $? -ne 0 ]; then
                    log_error "Error installing PipeWire modules for ALSA and JACK. Please check your internet connection and try again."
                    exit 1
                fi
                log_info "PipeWire modules for ALSA and JACK installed successfully"
                # disable PulseAudio
                sudo systemctl stop pulseaudio
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping PulseAudio. It may not be installed on your system."
                fi
                sudo systemctl disable pulseaudio
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling PulseAudio. It may not be installed on your system."
                fi
                break
                ;;
            "PulseAudio")
                log_info "Installing PipeWire modules for PulseAudio"
                sudo dnf install -y pipewire-modules-pulseaudio
                if [ $? -ne 0 ]; then
                    log_error "Error installing PipeWire modules for PulseAudio. Please check your internet connection and try again."
                    exit 1
                fi
                log_info "PipeWire modules for PulseAudio installed successfully"
                # disable ALSA and JACK
                sudo systemctl stop alsa-restore.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping alsa-restore service. It may not be installed on your system."
                fi
                sudo systemctl stop alsa-state.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping alsa-state service. It may not be installed on your system."
                fi
                sudo systemctl stop jackd.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping jackd service. It may not be installed on your system."
                fi
                sudo systemctl disable alsa-restore.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling alsa-restore service. It may not be installed on your system."
                fi
                sudo systemctl disable alsa-state.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling alsa-state service. It may not be installed on your system."
                fi
                sudo systemctl disable jackd.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling jackd service. It may not be installed on your system."
                fi
                break
                ;;
            *) echo "Invalid option";;
        esac
    done
else
    log_info "PipeWire is not installed. Installing PipeWire and its dependencies"
    if [ $? -ne 0 ]; then
        log_error "Error adding PipeWire PPA. Please check your internet connection and try again."
        exit 1
    fi
    sudo dnf update
    if [ $? -ne 0 ]; then
        log_error "Error updating package lists. Please check your internet connection and try again."
        exit 1
    fi
    sudo dnf install -y pipewire
    if [ $? -ne 0 ]; then
        log_error "Error installing PipeWire. Please check your internet connection and try again."
        exit 1
    fi
    echo "Which audio system do you want to use with PipeWire?"
    options=("ALSA and JACK" "PulseAudio")
    select opt in "${options[@]}"
    do
        case $opt in
            "ALSA and JACK")
                log_info "Installing PipeWire modules for ALSA and JACK"
                sudo dnf install -y pipewire pipewire-alsa pipewire-jack-audio-connection-kit
                if [ $? -ne 0 ]; then
                    log_error "Error installing PipeWire modules for ALSA and JACK. Please check your internet connection and try again."
                    exit 1
                fi
                log_info "PipeWire modules for ALSA and JACK installed successfully"
                # disable PulseAudio
                sudo systemctl stop pulseaudio
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping PulseAudio. It may not be installed on your system."
                fi
                sudo systemctl disable pulseaudio
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling PulseAudio. It may not be installed on your system."
                fi
                break
                ;;
            "PulseAudio")
                log_info "Installing PipeWire modules for PulseAudio"
                sudo dnf install -y pipewire-pulseaudio

                if [ $? -ne 0 ]; then
                    log_error "Error installing PipeWire modules for PulseAudio. Please check your internet connection and try again."
                    exit 1
                fi
                log_info "PipeWire modules for PulseAudio installed successfully"
                # disable ALSA and JACK
                sudo systemctl stop alsa-restore.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping alsa-restore service. It may not be installed on your system."
                fi
                sudo systemctl stop alsa-state.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping alsa-state service. It may not be installed on your system."
                fi
                sudo systemctl stop jackd.service
                if [ $? -ne 0 ]; then
                    log_warning "Error stopping jackd service. It may not be installed on your system."
                fi
                sudo systemctl disable alsa-restore.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling alsa-restore service. It may not be installed on your system."
                fi
                sudo systemctl disable alsa-state.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling alsa-state service. It may not be installed on your system."
                fi
                sudo systemctl disable jackd.service
                if [ $? -ne 0 ]; then
                    log_warning "Error disabling jackd service. It may not be installed on your system."
                fi
                break
                ;;
            *) echo "Invalid option";;
        esac
    done
fi

log_info "PipeWire configuration complete"
