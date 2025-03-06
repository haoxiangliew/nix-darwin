let
  id_ed25519-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWV7f+a1O76IZZVGae/peu3C6JUxJjhZ8jBtvtJZ1KD haoxiangliew@gmail.com";
in
{
  "id_ed25519.age".publicKeys = [ id_ed25519-key ];
  "gh_token.age".publicKeys = [ id_ed25519-key ];
  "gcp-rsa.age".publicKeys = [ id_ed25519-key ];
  "gpg-haoxiangliew.age".publicKeys = [ id_ed25519-key ];
  "expand-key.age".publicKeys = [ id_ed25519-key ];
}
