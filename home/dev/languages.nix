{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bruno
    (aspellWithDicts (
      dicts: with dicts; [
        en
        es
      ]
    ))
  ];
}
