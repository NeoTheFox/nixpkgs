{ stdenv, fetchFromGitHub, which, curl, makeWrapper, jdk }:

let
  rev = "1e9230f35879ce23cbd8d16add07d2134fd479c9";
  version = "2020-09-24";
in
stdenv.mkDerivation {
  name = "sbt-extras-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "1k6vknjjbhr5jfpiyh2yzayn2ziqi1bb862l1q2786q59161ij3j";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    substituteInPlace bin/sbt --replace 'declare java_cmd="java"' 'declare java_cmd="${jdk}/bin/java"'

    install bin/sbt $out/bin

    wrapProgram $out/bin/sbt --prefix PATH : ${stdenv.lib.makeBinPath [ which curl ]}
  '';

  meta = {
    description = "A more featureful runner for sbt, the simple/scala/standard build tool";
    homepage = "https://github.com/paulp/sbt-extras";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
