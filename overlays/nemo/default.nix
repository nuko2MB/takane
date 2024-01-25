# Overlay unstable version of nemo. New nemo release fixes annoying context menu bug.
{ channels, ... }:
final: prev: {
  cinnamon = prev.cinnamon.overrideScope' (
    cfinal: cprev: { inherit (channels.unstable.cinnamon) nemo; }
  );
}
