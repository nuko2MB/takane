{ matugen, ... }: final: prev: { matugen = matugen.packages.${prev.system}.default; }
