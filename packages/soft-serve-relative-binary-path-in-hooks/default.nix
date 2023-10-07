{ soft-serve }: soft-serve.overrideAttrs (o: {
  patches = [
    ./executable-name.patch
  ];
})
