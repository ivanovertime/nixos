{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (aspellWithDicts (
      dicts: with dicts; [
        en
        es
      ]
    ))
  ];
}
