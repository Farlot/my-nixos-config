{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    # acceleration = "cuda"; # Uncomment for NVIDIA
    # acceleration = "rocm"; # Uncomment for AMD
  };

  # Optional: Add a web interface (ChatGPT-like)
  services.open-webui = {
    enable = true;
    port = 8080;
  };
}
