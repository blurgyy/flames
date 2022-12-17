{ generated, source, lib, rustPlatform
, writeText
}: rustPlatform.buildRustPackage {
  inherit (source) pname version src;

  cargoPatches = [
    (writeText "async-speed-limit.patch" ''
      diff --git a/Cargo.lock b/Cargo.lock
      index 9c7bc1d..66ae26e 100644
      --- a/Cargo.lock
      +++ b/Cargo.lock
      @@ -15,13 +15,22 @@ dependencies = [
       
       [[package]]
       name = "aho-corasick"
      -version = "0.7.18"
      +version = "0.7.20"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1e37cfd5e7657ada45f742d6e99ca5788580b5c529dc78faf11ece6dc702656f"
      +checksum = "cc936419f96fa211c1b9166887b38e5e40b19958e5b895be7c1f93adec7071ac"
       dependencies = [
        "memchr",
       ]
       
      +[[package]]
      +name = "android_system_properties"
      +version = "0.1.5"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "819e7219dbd41043ac279b19830f2efc897156490d7fd6ea916720117ee66311"
      +dependencies = [
      + "libc",
      +]
      +
       [[package]]
       name = "ansi_term"
       version = "0.12.1"
      @@ -33,9 +42,9 @@ dependencies = [
       
       [[package]]
       name = "anyhow"
      -version = "1.0.57"
      +version = "1.0.66"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "08f9b8508dccb7687a1d6c4ce66b2b0ecef467c94667de27d8d7fe1f8d2a9cdc"
      +checksum = "216261ddc8289130e551ddcd5ce8a064710c0d064a4d2895c67151c92b5443f6"
       
       [[package]]
       name = "arrayvec"
      @@ -45,8 +54,7 @@ checksum = "23b62fc65de8e4e7f52534fb52b0f3ed04746ae267519eef2a83941e8085068b"
       
       [[package]]
       name = "async-speed-limit"
      -version = "0.3.1"
      -source = "git+https://github.com/open-trade/async-speed-limit#f89f702ae01d4016429543d2f0dda1086157e420"
      +version = "0.3.1-1"
       dependencies = [
        "futures-core",
        "futures-io",
      @@ -56,9 +64,9 @@ dependencies = [
       
       [[package]]
       name = "async-trait"
      -version = "0.1.53"
      +version = "0.1.58"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "ed6aa3524a2dfcf9fe180c51eae2b58738348d819517ceadf95789c51fff7600"
      +checksum = "1e805d94e6b5001b651426cf4cd446b1ab5f319d27bab5c644f61de0a804360c"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -93,9 +101,9 @@ checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"
       
       [[package]]
       name = "axum"
      -version = "0.5.5"
      +version = "0.5.17"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "00f1e8a972137fad81e2a1a60b86ff17ce0338f8017264e45a9723d0083c39a1"
      +checksum = "acee9fd5073ab6b045a275b3e709c163dd36c90685219cb21804a147b58dba43"
       dependencies = [
        "async-trait",
        "axum-core",
      @@ -125,9 +133,9 @@ dependencies = [
       
       [[package]]
       name = "axum-core"
      -version = "0.2.4"
      +version = "0.2.9"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "da31c0ed7b4690e2c78fe4b880d21cd7db04a346ebc658b4270251b695437f17"
      +checksum = "37e5939e02c56fecd5c017c37df4238c0a839fa76b7f97acdd7efb804fd181cc"
       dependencies = [
        "async-trait",
        "bytes",
      @@ -135,13 +143,15 @@ dependencies = [
        "http",
        "http-body",
        "mime",
      + "tower-layer",
      + "tower-service",
       ]
       
       [[package]]
       name = "base64"
      -version = "0.13.0"
      +version = "0.13.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "904dfeac50f3cdaba28fc6f57fdcddb75f49ed61346676a78c4ffe55877802fd"
      +checksum = "9e1b586273c5702936fe7b7d6896644d8be71e6314cfe09d3167c95f712589e8"
       
       [[package]]
       name = "bcrypt"
      @@ -163,9 +173,9 @@ checksum = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"
       
       [[package]]
       name = "block-buffer"
      -version = "0.10.2"
      +version = "0.10.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0bf7fe51849ea569fd452f37822f606a5cabb684dc918707a0193fd4664ff324"
      +checksum = "69cce20737498f97b993470a6e536b8523f0af7892a4f928cceb1ac5e52ebe7e"
       dependencies = [
        "generic-array",
       ]
      @@ -182,9 +192,9 @@ dependencies = [
       
       [[package]]
       name = "bumpalo"
      -version = "3.9.1"
      +version = "3.11.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "a4a45a46ab1f2412e53d3a0ade76ffad2025804294569aae387231a0cd6e0899"
      +checksum = "572f695136211188308f16ad2ca5c851a712c464060ae6974944458eb83880ba"
       
       [[package]]
       name = "byteorder"
      @@ -194,15 +204,15 @@ checksum = "14c189c53d098945499cdfa7ecc63567cf3886b3332b312a5b4585d8d3a6a610"
       
       [[package]]
       name = "bytes"
      -version = "1.2.0"
      +version = "1.3.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f0b3de4a0c5e67e16066a0715723abd91edc2f9001d09c46e1dca929351e130e"
      +checksum = "dfb24e866b15a1af2a1b663f10c6b6b8f397a84aadb828f12e5b289ec23a3a3c"
       
       [[package]]
       name = "cc"
      -version = "1.0.73"
      +version = "1.0.77"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "2fff2a6927b3bb87f9595d67196a70493f627687a71d87a0d692242c33f58c11"
      +checksum = "e9f73505338f7d905b19d18738976aae232eb46b8efc15554ffc56deb5d9ebe4"
       dependencies = [
        "jobserver",
       ]
      @@ -215,14 +225,16 @@ checksum = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"
       
       [[package]]
       name = "chrono"
      -version = "0.4.19"
      +version = "0.4.23"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "670ad68c9088c2a963aaa298cb369688cf3f9465ce5e2d4ca10e6e0098a1ce73"
      +checksum = "16b0a3d9ed01224b22057780a37bb8c5dbfe1be8ba48678e7bf57ec4b385411f"
       dependencies = [
      - "libc",
      + "iana-time-zone",
      + "js-sys",
        "num-integer",
        "num-traits",
      - "time 0.1.43",
      + "time 0.1.45",
      + "wasm-bindgen",
        "winapi",
       ]
       
      @@ -251,6 +263,16 @@ dependencies = [
        "vec_map",
       ]
       
      +[[package]]
      +name = "codespan-reporting"
      +version = "0.11.1"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "3538270d33cc669650c4b093848450d380def10c331d38c768e34cac80576e6e"
      +dependencies = [
      + "termcolor",
      + "unicode-width",
      +]
      +
       [[package]]
       name = "config"
       version = "0.11.0"
      @@ -273,12 +295,6 @@ dependencies = [
        "toml",
       ]
       
      -[[package]]
      -name = "const-sha1"
      -version = "0.2.0"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "fb58b6451e8c2a812ad979ed1d83378caa5e927eef2622017a45f251457c2c9d"
      -
       [[package]]
       name = "core-foundation"
       version = "0.9.3"
      @@ -297,9 +313,9 @@ checksum = "5827cebf4670468b8772dd191856768aedcb1b0278a04f989f7766351917b9dc"
       
       [[package]]
       name = "cpufeatures"
      -version = "0.2.2"
      +version = "0.2.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "59a6001667ab124aebae2a495118e11d30984c3a653e99d86d58971708cf5e4b"
      +checksum = "28d997bd5e24a5928dd43e46dc529867e207907fe0b239c3477d924f7f2ca320"
       dependencies = [
        "libc",
       ]
      @@ -320,82 +336,86 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "2d0165d2900ae6778e36e80bbc4da3b5eefccee9ba939761f9c2882a5d9af3ff"
       
       [[package]]
      -name = "crossbeam"
      -version = "0.8.1"
      +name = "crossbeam-channel"
      +version = "0.5.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "4ae5588f6b3c3cb05239e90bd110f257254aecd01e4635400391aeae07497845"
      +checksum = "c2dd04ddaf88237dc3b8d8f9a3c1004b506b54b3313403944054d23c0870c521"
       dependencies = [
        "cfg-if",
      - "crossbeam-channel",
      - "crossbeam-deque",
      - "crossbeam-epoch",
      - "crossbeam-queue",
        "crossbeam-utils",
       ]
       
       [[package]]
      -name = "crossbeam-channel"
      -version = "0.5.4"
      +name = "crossbeam-queue"
      +version = "0.3.8"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "5aaa7bd5fb665c6864b5f963dd9097905c54125909c7aa94c9e18507cdbe6c53"
      +checksum = "d1cfb3ea8a53f37c40dea2c7bedcbd88bdfae54f5e2175d6ecaff1c988353add"
       dependencies = [
        "cfg-if",
        "crossbeam-utils",
       ]
       
       [[package]]
      -name = "crossbeam-deque"
      -version = "0.8.1"
      +name = "crossbeam-utils"
      +version = "0.8.14"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "6455c0ca19f0d2fbf751b908d5c55c1f5cbc65e03c4225427254b46890bdde1e"
      +checksum = "4fb766fa798726286dbbb842f174001dab8abc7b627a1dd86e0b7222a95d929f"
       dependencies = [
        "cfg-if",
      - "crossbeam-epoch",
      - "crossbeam-utils",
       ]
       
       [[package]]
      -name = "crossbeam-epoch"
      -version = "0.9.8"
      +name = "crypto-common"
      +version = "0.1.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1145cf131a2c6ba0615079ab6a638f7e1973ac9c2634fcbeaaad6114246efe8c"
      +checksum = "1bfb12502f3fc46cca1bb51ac28df9d618d813cdc3d2f25b9fe775a34af26bb3"
       dependencies = [
      - "autocfg",
      - "cfg-if",
      - "crossbeam-utils",
      - "lazy_static",
      - "memoffset",
      - "scopeguard",
      + "generic-array",
      + "typenum",
       ]
       
       [[package]]
      -name = "crossbeam-queue"
      -version = "0.3.5"
      +name = "cxx"
      +version = "1.0.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1f25d8400f4a7a5778f0e4e52384a48cbd9b5c495d110786187fc750075277a2"
      +checksum = "bdf07d07d6531bfcdbe9b8b739b104610c6508dcc4d63b410585faf338241daf"
       dependencies = [
      - "cfg-if",
      - "crossbeam-utils",
      + "cc",
      + "cxxbridge-flags",
      + "cxxbridge-macro",
      + "link-cplusplus",
       ]
       
       [[package]]
      -name = "crossbeam-utils"
      -version = "0.8.8"
      +name = "cxx-build"
      +version = "1.0.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0bf124c720b7686e3c2663cf54062ab0f68a88af2fb6a030e87e30bf721fcb38"
      +checksum = "d2eb5b96ecdc99f72657332953d4d9c50135af1bac34277801cc3937906ebd39"
       dependencies = [
      - "cfg-if",
      - "lazy_static",
      + "cc",
      + "codespan-reporting",
      + "once_cell",
      + "proc-macro2",
      + "quote",
      + "scratch",
      + "syn",
       ]
       
       [[package]]
      -name = "crypto-common"
      -version = "0.1.3"
      +name = "cxxbridge-flags"
      +version = "1.0.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "57952ca27b5e3606ff4dd79b0020231aaf9d6aa76dc05fd30137538c50bd3ce8"
      +checksum = "ac040a39517fd1674e0f32177648334b0f4074625b5588a64519804ba0553b12"
      +
      +[[package]]
      +name = "cxxbridge-macro"
      +version = "1.0.83"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "1362b0ddcfc4eb0a1f57b68bd77dd99f0e826958a96abd0ae9bd092e114ffed6"
       dependencies = [
      - "generic-array",
      - "typenum",
      + "proc-macro2",
      + "quote",
      + "syn",
       ]
       
       [[package]]
      @@ -413,9 +433,9 @@ dependencies = [
       
       [[package]]
       name = "digest"
      -version = "0.10.3"
      +version = "0.10.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f2fb860ca6fafa5552fb6d0e816a69c8e49f0908bf524e30a90d97c85892d506"
      +checksum = "8168378f4e5023e7218c89c891c0fd8ecdb5e5e4f18cb78f38cf245dd021e76f"
       dependencies = [
        "block-buffer",
        "crypto-common",
      @@ -459,31 +479,43 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "0688c2a7f92e427f44895cd63841bff7b29f8d7a1648b9e7e07a4a365b2e1257"
       
       [[package]]
      -name = "dotenv"
      -version = "0.15.0"
      +name = "dns-lookup"
      +version = "1.0.8"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "53ecafc952c4528d9b51a458d1a8904b81783feff9fde08ab6ed2545ff396872"
      +dependencies = [
      + "cfg-if",
      + "libc",
      + "socket2 0.4.7",
      + "winapi",
      +]
      +
      +[[package]]
      +name = "dotenvy"
      +version = "0.15.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "77c90badedccf4105eca100756a0b1289e191f6fcbdadd3cee1d2f614f97da8f"
      +checksum = "03d8c417d7a8cb362e0c37e5d815f5eb7c37f79ff93707329d5a194e42e54ca0"
       
       [[package]]
       name = "ed25519"
      -version = "1.5.0"
      +version = "1.5.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d916019f70ae3a1faa1195685e290287f39207d38e6dfee727197cffcc002214"
      +checksum = "1e9c280362032ea4203659fc489832d0204ef09f247a0506f170dafcac08c369"
       dependencies = [
        "signature",
       ]
       
       [[package]]
       name = "either"
      -version = "1.6.1"
      +version = "1.8.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "e78d4f1cc4ae33bbfc157ed5d5a5ef3bc29227303d595861deb238fcec4e9457"
      +checksum = "90e5c1c8368803113bf0c9584fc495a58b86dc8a29edbf8fe877d21d9507e797"
       
       [[package]]
       name = "env_logger"
      -version = "0.9.0"
      +version = "0.9.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0b2cf0344971ee6c64c31be0d530793fba457d322dfec2810c453d0ef228f9c3"
      +checksum = "a12e6657c4c97ebab115a42dcee77225f7f482cdd841cf7088c657a42e9e00e7"
       dependencies = [
        "atty",
        "humantime",
      @@ -494,41 +526,42 @@ dependencies = [
       
       [[package]]
       name = "event-listener"
      -version = "2.5.2"
      +version = "2.5.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "77f3309417938f28bf8228fcff79a4a37103981e3e186d2ccd19c74b38f4eb71"
      +checksum = "0206175f82b8d6bf6652ff7d71a1e27fd2e4efde587fd368662814d6ec1d9ce0"
       
       [[package]]
       name = "fastrand"
      -version = "1.7.0"
      +version = "1.8.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "c3fcf0cee53519c866c09b5de1f6c56ff9d647101f81c1964fa632e148896cdf"
      +checksum = "a7a407cfaa3385c4ae6b23e84623d48c2798d06e3e6a1878f7f59f17b3f86499"
       dependencies = [
        "instant",
       ]
       
       [[package]]
       name = "filetime"
      -version = "0.2.16"
      +version = "0.2.18"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "c0408e2626025178a6a7f7ffc05a25bc47103229f19c113755de7bf63816290c"
      +checksum = "4b9663d381d07ae25dc88dbdf27df458faa83a9b25336bcac83d5e452b5fc9d3"
       dependencies = [
        "cfg-if",
        "libc",
        "redox_syscall",
      - "winapi",
      + "windows-sys 0.42.0",
       ]
       
       [[package]]
       name = "flexi_logger"
      -version = "0.22.3"
      +version = "0.22.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "969940c39bc718475391e53a3a59b0157e64929c80cf83ad5dde5f770ecdc423"
      +checksum = "0c76a80dd14a27fc3d8bc696502132cb52b3f227256fd8601166c3a35e45f409"
       dependencies = [
        "ansi_term",
        "atty",
        "chrono",
      - "crossbeam",
      + "crossbeam-channel",
      + "crossbeam-queue",
        "glob",
        "lazy_static",
        "log",
      @@ -540,14 +573,14 @@ dependencies = [
       
       [[package]]
       name = "flume"
      -version = "0.10.12"
      +version = "0.10.14"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "843c03199d0c0ca54bc1ea90ac0d507274c28abcc4f691ae8b4eaa375087c76a"
      +checksum = "1657b4441c3403d9f7b3409e47575237dac27b1b5726df654a6ecbf92f0f7577"
       dependencies = [
        "futures-core",
        "futures-sink",
        "pin-project",
      - "spin 0.9.3",
      + "spin 0.9.4",
       ]
       
       [[package]]
      @@ -558,19 +591,18 @@ checksum = "3f9eec918d3f24069decb9af1554cad7c880e2da24a9afd88aca000531ab82c1"
       
       [[package]]
       name = "form_urlencoded"
      -version = "1.0.1"
      +version = "1.1.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "5fc25a87fa4fd2094bffb06925852034d90a17f0d1e05197d4956d3555752191"
      +checksum = "a9c384f161156f5260c24a097c56119f9be8c798586aecc13afbcbe7b7e26bf8"
       dependencies = [
      - "matches",
        "percent-encoding",
       ]
       
       [[package]]
       name = "futures"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f73fe65f54d1e12b726f517d3e2135ca3125a437b6d998caf1962961f7172d9e"
      +checksum = "38390104763dc37a5145a53c29c63c1290b5d316d6086ec32c293f6736051bb0"
       dependencies = [
        "futures-channel",
        "futures-core",
      @@ -583,9 +615,9 @@ dependencies = [
       
       [[package]]
       name = "futures-channel"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "c3083ce4b914124575708913bca19bfe887522d6e2e6d0952943f5eac4a74010"
      +checksum = "52ba265a92256105f45b719605a571ffe2d1f0fea3807304b522c1d778f79eed"
       dependencies = [
        "futures-core",
        "futures-sink",
      @@ -593,15 +625,15 @@ dependencies = [
       
       [[package]]
       name = "futures-core"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0c09fd04b7e4073ac7156a9539b57a484a8ea920f79c7c675d05d289ab6110d3"
      +checksum = "04909a7a7e4633ae6c4a9ab280aeb86da1236243a77b694a49eacd659a4bd3ac"
       
       [[package]]
       name = "futures-executor"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9420b90cfa29e327d0429f19be13e7ddb68fa1cccb09d65e5706b8c7a749b8a6"
      +checksum = "7acc85df6714c176ab5edf386123fafe217be88c0840ec11f199441134a074e2"
       dependencies = [
        "futures-core",
        "futures-task",
      @@ -610,9 +642,9 @@ dependencies = [
       
       [[package]]
       name = "futures-intrusive"
      -version = "0.4.0"
      +version = "0.4.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "62007592ac46aa7c2b6416f7deb9a8a8f63a01e0f1d6e1787d5630170db2b63e"
      +checksum = "a604f7a68fbf8103337523b1fadc8ade7361ee3f112f7c680ad179651616aed5"
       dependencies = [
        "futures-core",
        "lock_api",
      @@ -621,15 +653,15 @@ dependencies = [
       
       [[package]]
       name = "futures-io"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "fc4045962a5a5e935ee2fdedaa4e08284547402885ab326734432bed5d12966b"
      +checksum = "00f5fb52a06bdcadeb54e8d3671f8888a39697dcb0b81b23b55174030427f4eb"
       
       [[package]]
       name = "futures-macro"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "33c1e13800337f4d4d7a316bf45a567dbcb6ffe087f16424852d97e97a91f512"
      +checksum = "bdfb8ce053d86b91919aad980c220b1fb8401a9394410e1c289ed7e66b61835d"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -638,15 +670,15 @@ dependencies = [
       
       [[package]]
       name = "futures-sink"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "21163e139fa306126e6eedaf49ecdb4588f939600f0b1e770f4205ee4b7fa868"
      +checksum = "39c15cf1a4aa79df40f1bb462fb39676d0ad9e366c2a33b590d7c66f4f81fcf9"
       
       [[package]]
       name = "futures-task"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "57c66a976bf5909d801bbef33416c41372779507e7a6b3a5e25e4749c58f776a"
      +checksum = "2ffb393ac5d9a6eaa9d3fdf37ae2776656b706e200c8e16b1bdb227f5198e6ea"
       
       [[package]]
       name = "futures-timer"
      @@ -656,9 +688,9 @@ checksum = "e64b03909df88034c26dc1547e8970b91f98bdb65165d6a4e9110d94263dbb2c"
       
       [[package]]
       name = "futures-util"
      -version = "0.3.21"
      +version = "0.3.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d8b7abd5d659d9b90c8cba917f6ec750a74e2dc23902ef9cd4cc8c8b22e6036a"
      +checksum = "197676987abd2f9cadff84926f410af1c183608d36641465df73ae8211dc65d6"
       dependencies = [
        "futures-channel",
        "futures-core",
      @@ -683,9 +715,9 @@ dependencies = [
       
       [[package]]
       name = "generic-array"
      -version = "0.14.5"
      +version = "0.14.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "fd48d33ec7f05fbfa152300fdad764757cbded343c1aa1cff2fbaf4134851803"
      +checksum = "bff49e947297f3312447abdca79f45f4738097cc82b06e72054d2223f601f1b9"
       dependencies = [
        "typenum",
        "version_check",
      @@ -693,13 +725,13 @@ dependencies = [
       
       [[package]]
       name = "getrandom"
      -version = "0.2.6"
      +version = "0.2.8"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9be70c98951c83b8d2f8f60d7065fa6d5146873094452a1008da8c2f1e4205ad"
      +checksum = "c05aeb6a22b8f62540c194aac980f2115af067bfe15a0734d7277a768d396b31"
       dependencies = [
        "cfg-if",
        "libc",
      - "wasi 0.10.2+wasi-snapshot-preview1",
      + "wasi 0.11.0+wasi-snapshot-preview1",
       ]
       
       [[package]]
      @@ -710,26 +742,20 @@ checksum = "9b919933a397b79c37e33b77bb2aa3dc8eb6e165ad809e58ff75bc7db2e34574"
       
       [[package]]
       name = "hashbrown"
      -version = "0.11.2"
      +version = "0.12.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "ab5ef0d4909ef3724cc8cce6ccc8572c5c817592e9285f5464f8e86f8bd3726e"
      -
      -[[package]]
      -name = "hashbrown"
      -version = "0.12.1"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "db0d4cf898abf0081f964436dc980e96670a0f36863e4b83aaacdb65c9d7ccc3"
      +checksum = "8a9ee70c43aaf417c914396645a0fa852624801b24ebb7ae78fe8272889ac888"
       dependencies = [
        "ahash",
       ]
       
       [[package]]
       name = "hashlink"
      -version = "0.8.0"
      +version = "0.8.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d452c155cb93fecdfb02a73dd57b5d8e442c2063bd7aac72f1bc5e4263a43086"
      +checksum = "69fe1fcf8b4278d860ad0548329f892a3631fb63f82574df68275f34cdbe0ffa"
       dependencies = [
      - "hashbrown 0.12.1",
      + "hashbrown",
       ]
       
       [[package]]
      @@ -760,7 +786,7 @@ dependencies = [
        "sodiumoxide",
        "tokio",
        "tokio-socks",
      - "tokio-util 0.7.1",
      + "tokio-util",
        "toml",
        "winapi",
        "zstd",
      @@ -778,6 +804,7 @@ dependencies = [
        "chrono",
        "clap",
        "deadpool",
      + "dns-lookup",
        "flexi_logger",
        "hbb_common",
        "headers",
      @@ -790,6 +817,7 @@ dependencies = [
        "machine-uid",
        "minreq",
        "once_cell",
      + "ping",
        "regex",
        "rust-ini",
        "serde",
      @@ -806,9 +834,9 @@ dependencies = [
       
       [[package]]
       name = "headers"
      -version = "0.3.7"
      +version = "0.3.8"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "4cff78e5788be1e0ab65b04d306b2ed5092c815ec97ec70f4ebd5aee158aa55d"
      +checksum = "f3e372db8e5c0d213e0cd0b9be18be2aca3d44cf2fe30a9d46a65581cd454584"
       dependencies = [
        "base64",
        "bitflags",
      @@ -817,7 +845,7 @@ dependencies = [
        "http",
        "httpdate",
        "mime",
      - "sha-1",
      + "sha1",
       ]
       
       [[package]]
      @@ -855,9 +883,9 @@ checksum = "7f24254aa9a54b5c858eaee2f5bccdb46aaf0e486a595ed5fd8f86ba55232a70"
       
       [[package]]
       name = "http"
      -version = "0.2.7"
      +version = "0.2.8"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "ff8670570af52249509a86f5e3e18a08c60b177071826898fde8997cf5f6bfbb"
      +checksum = "75f43d41e26995c17e71ee126451dd3941010b0514a81a9d11f3b341debc2399"
       dependencies = [
        "bytes",
        "fnv",
      @@ -866,9 +894,9 @@ dependencies = [
       
       [[package]]
       name = "http-body"
      -version = "0.4.4"
      +version = "0.4.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1ff4f84919677303da5f147645dbea6b1881f368d03ac84e1dc09031ebd7b2c6"
      +checksum = "d5f38f16d184e36f2408a55281cd658ecbd3ca05cce6d6510a176eca393e26d1"
       dependencies = [
        "bytes",
        "http",
      @@ -883,9 +911,9 @@ checksum = "0bfe8eed0a9285ef776bb792479ea3834e8b94e13d615c2f66d03dd50a435a29"
       
       [[package]]
       name = "httparse"
      -version = "1.7.1"
      +version = "1.8.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "496ce29bb5a52785b44e0f7ca2847ae0bb839c9bd28f69acac9b99d461c0c04c"
      +checksum = "d897f394bad6a705d5f4104762e116a75639e470d80901eed05a860a95cb1904"
       
       [[package]]
       name = "httpdate"
      @@ -901,9 +929,9 @@ checksum = "9a3a5bfb195931eeb336b2a7b4d761daec841b97f947d34394601737a7bba5e4"
       
       [[package]]
       name = "hyper"
      -version = "0.14.18"
      +version = "0.14.23"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "b26ae0a80afebe130861d90abf98e3814a4f28a4c6ffeb5ab8ebb2be311e0ef2"
      +checksum = "034711faac9d2166cb1baf1a2fb0b60b1f277f8492fd72176c17f3515e1abd3c"
       dependencies = [
        "bytes",
        "futures-channel",
      @@ -915,32 +943,55 @@ dependencies = [
        "httpdate",
        "itoa",
        "pin-project-lite",
      - "socket2 0.4.4",
      + "socket2 0.4.7",
        "tokio",
        "tower-service",
        "tracing",
        "want",
       ]
       
      +[[package]]
      +name = "iana-time-zone"
      +version = "0.1.53"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "64c122667b287044802d6ce17ee2ddf13207ed924c712de9a66a5814d5b64765"
      +dependencies = [
      + "android_system_properties",
      + "core-foundation-sys",
      + "iana-time-zone-haiku",
      + "js-sys",
      + "wasm-bindgen",
      + "winapi",
      +]
      +
      +[[package]]
      +name = "iana-time-zone-haiku"
      +version = "0.1.1"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "0703ae284fc167426161c2e3f1da3ea71d94b21bedbcc9494e92b28e334e3dca"
      +dependencies = [
      + "cxx",
      + "cxx-build",
      +]
      +
       [[package]]
       name = "idna"
      -version = "0.2.3"
      +version = "0.3.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "418a0a6fab821475f634efe3ccc45c013f742efe03d853e8d3355d5cb850ecf8"
      +checksum = "e14ddfc70884202db2244c223200c204c2bda1bc6e0998d11b5e024d657209e6"
       dependencies = [
      - "matches",
        "unicode-bidi",
        "unicode-normalization",
       ]
       
       [[package]]
       name = "indexmap"
      -version = "1.8.1"
      +version = "1.9.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0f647032dfaa1f8b6dc29bd3edb7bbef4861b8b8007ebb118d6db284fd59f6ee"
      +checksum = "1885e79c1fc4b10f0e172c475f458b7f7b93061064d98c3293e98c5ba0c8b399"
       dependencies = [
        "autocfg",
      - "hashbrown 0.11.2",
      + "hashbrown",
       ]
       
       [[package]]
      @@ -972,42 +1023,42 @@ dependencies = [
       
       [[package]]
       name = "itertools"
      -version = "0.10.3"
      +version = "0.10.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "a9a9d19fa1e79b6215ff29b9d6880b706147f16e9b1dbb1e4e5947b5b02bc5e3"
      +checksum = "b0fd2260e829bddf4cb6ea802289de2f86d6a7a690192fbe91b3f46e0f2c8473"
       dependencies = [
        "either",
       ]
       
       [[package]]
       name = "itoa"
      -version = "1.0.1"
      +version = "1.0.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1aab8fc367588b89dcee83ab0fd66b72b50b72fa1904d7095045ace2b0c81c35"
      +checksum = "4217ad341ebadf8d8e724e264f13e593e0648f5b3e94b3896a5df283be015ecc"
       
       [[package]]
       name = "jobserver"
      -version = "0.1.24"
      +version = "0.1.25"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "af25a77299a7f711a01975c35a6a424eb6862092cc2d6c72c4ed6cbc56dfc1fa"
      +checksum = "068b1ee6743e4d11fb9c6a1e6064b3693a1b600e7f5f5988047d98b3dc9fb90b"
       dependencies = [
        "libc",
       ]
       
       [[package]]
       name = "js-sys"
      -version = "0.3.57"
      +version = "0.3.60"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "671a26f820db17c2a2750743f1dd03bafd15b98c9f30c7c2628c024c05d73397"
      +checksum = "49409df3e3bf0856b916e2ceaca09ee28e6871cf7d9ce97a692cacfdb2a25a47"
       dependencies = [
        "wasm-bindgen",
       ]
       
       [[package]]
       name = "jsonwebtoken"
      -version = "8.1.0"
      +version = "8.1.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "cc9051c17f81bae79440afa041b3a278e1de71bfb96d32454b477fd4703ccb6f"
      +checksum = "1aa4b4af834c6cfd35d8763d359661b90f2e45d8f750a0849156c7f4671af09c"
       dependencies = [
        "base64",
        "pem",
      @@ -1038,9 +1089,9 @@ dependencies = [
       
       [[package]]
       name = "libc"
      -version = "0.2.125"
      +version = "0.2.137"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "5916d2ae698f6de9bfb891ad7a8d65c09d232dc58cc4ac433c7da3b2fd84bc2b"
      +checksum = "fc7fcc620a3bff7cdd7a365be3376c97191aeaccc2a603e600951e452615bf89"
       
       [[package]]
       name = "libsodium-sys"
      @@ -1065,24 +1116,32 @@ dependencies = [
        "vcpkg",
       ]
       
      +[[package]]
      +name = "link-cplusplus"
      +version = "1.0.7"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "9272ab7b96c9046fbc5bc56c06c117cb639fe2d509df0c421cad82d2915cf369"
      +dependencies = [
      + "cc",
      +]
      +
       [[package]]
       name = "local-ip-address"
      -version = "0.4.4"
      +version = "0.4.9"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "8b143c6ef86e36328caa40a7578e95d1544aca8a1740235fd2b416a69441a5c7"
      +checksum = "9eab7f092fb08006040e656c2adce6670e6a516bea831a8b2b3d0fb24d4488f5"
       dependencies = [
        "libc",
      - "memalloc",
        "neli",
        "thiserror",
      - "windows",
      + "windows-sys 0.42.0",
       ]
       
       [[package]]
       name = "lock_api"
      -version = "0.4.7"
      +version = "0.4.9"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "327fa5b6a6940e4699ec49a9beae1ea4845c6bab9314e4f84ac68742139d8c53"
      +checksum = "435011366fe56583b16cf956f9df0095b405b82d76425bc8981c0e22e60ec4df"
       dependencies = [
        "autocfg",
        "scopeguard",
      @@ -1099,9 +1158,9 @@ dependencies = [
       
       [[package]]
       name = "mac_address"
      -version = "1.1.3"
      +version = "1.1.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "df1d1bc1084549d60725ccc53a2bfa07f67fe4689fda07b05a36531f2988104a"
      +checksum = "b238e3235c8382b7653c6408ed1b08dd379bdb9fdf990fb0bbae3db2cc0ae963"
       dependencies = [
        "nix",
        "winapi",
      @@ -1116,24 +1175,12 @@ dependencies = [
        "winreg",
       ]
       
      -[[package]]
      -name = "matches"
      -version = "0.1.9"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "a3e378b66a060d48947b590737b30a1be76706c8dd7b8ba0f2fe3989c68a853f"
      -
       [[package]]
       name = "matchit"
       version = "0.5.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "73cbba799671b762df5a175adf59ce145165747bb891505c43d09aefbbf38beb"
       
      -[[package]]
      -name = "memalloc"
      -version = "0.1.0"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "df39d232f5c40b0891c10216992c2f250c054105cb1e56f0fc9032db6203ecc1"
      -
       [[package]]
       name = "memchr"
       version = "2.5.0"
      @@ -1183,36 +1230,14 @@ dependencies = [
       
       [[package]]
       name = "mio"
      -version = "0.7.14"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "8067b404fe97c70829f082dec8bcf4f71225d7eaea1d8645349cb76fa06205cc"
      -dependencies = [
      - "libc",
      - "log",
      - "miow",
      - "ntapi",
      - "winapi",
      -]
      -
      -[[package]]
      -name = "mio"
      -version = "0.8.3"
      +version = "0.8.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "713d550d9b44d89174e066b7a6217ae06234c10cb47819a88290d2b353c31799"
      +checksum = "e5d732bc30207a6423068df043e3d02e0735b155ad7ce1a6f76fe2baa5b158de"
       dependencies = [
        "libc",
        "log",
        "wasi 0.11.0+wasi-snapshot-preview1",
      - "windows-sys",
      -]
      -
      -[[package]]
      -name = "miow"
      -version = "0.3.7"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "b9f1c5b025cda876f66ef43a113f91ebc9f4ccef34843000e0adf6ebbab84e21"
      -dependencies = [
      - "winapi",
      + "windows-sys 0.42.0",
       ]
       
       [[package]]
      @@ -1259,15 +1284,6 @@ dependencies = [
        "minimal-lexical",
       ]
       
      -[[package]]
      -name = "ntapi"
      -version = "0.3.7"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "c28774a7fd2fbb4f0babd8237ce554b73af68021b5f695a3cebd6c59bac0980f"
      -dependencies = [
      - "winapi",
      -]
      -
       [[package]]
       name = "num-bigint"
       version = "0.4.3"
      @@ -1300,9 +1316,9 @@ dependencies = [
       
       [[package]]
       name = "num_cpus"
      -version = "1.13.1"
      +version = "1.14.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "19e64526ebdee182341572e50e9ad03965aa510cd94427a4549448f285e957a1"
      +checksum = "f6058e64324c71e02bc2b150e4f3bc8286db6c83092132ffa3f6b1eab0f9def5"
       dependencies = [
        "hermit-abi",
        "libc",
      @@ -1319,9 +1335,9 @@ dependencies = [
       
       [[package]]
       name = "once_cell"
      -version = "1.10.0"
      +version = "1.16.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "87f3e037eac156d1775da914196f0f37741a274155e34a0b7e427c35d2a2ecb9"
      +checksum = "86f0b0d4bf799edbc74508c1e8bf170ff5f41238e5f8225603ca7caaae2b7860"
       
       [[package]]
       name = "openssl-probe"
      @@ -1336,7 +1352,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "ccd746e37177e1711c20dd619a1620f34f5c8b569c53590a72dedd5344d8924a"
       dependencies = [
        "dlv-list",
      - "hashbrown 0.12.1",
      + "hashbrown",
       ]
       
       [[package]]
      @@ -1352,12 +1368,12 @@ dependencies = [
       
       [[package]]
       name = "parking_lot"
      -version = "0.12.0"
      +version = "0.12.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "87f5ec2493a61ac0506c0f4199f99070cbe83857b0337006a30f3e6719b8ef58"
      +checksum = "3742b2c103b9f06bc9fff0a37ff4912935851bee6d36f3c02bcc755bcfec228f"
       dependencies = [
        "lock_api",
      - "parking_lot_core 0.9.3",
      + "parking_lot_core 0.9.5",
       ]
       
       [[package]]
      @@ -1376,52 +1392,52 @@ dependencies = [
       
       [[package]]
       name = "parking_lot_core"
      -version = "0.9.3"
      +version = "0.9.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "09a279cbf25cb0757810394fbc1e359949b59e348145c643a939a525692e6929"
      +checksum = "7ff9f3fef3968a3ec5945535ed654cb38ff72d7495a25619e2247fb15a2ed9ba"
       dependencies = [
        "cfg-if",
        "libc",
        "redox_syscall",
        "smallvec",
      - "windows-sys",
      + "windows-sys 0.42.0",
       ]
       
       [[package]]
       name = "paste"
      -version = "1.0.7"
      +version = "1.0.9"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0c520e05135d6e763148b6426a837e239041653ba7becd2e538c076c738025fc"
      +checksum = "b1de2e551fb905ac83f73f7aedf2f0cb4a0da7e35efa24a202a936269f1f18e1"
       
       [[package]]
       name = "pem"
      -version = "1.0.2"
      +version = "1.1.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "e9a3b09a20e374558580a4914d3b7d89bd61b954a5a5e1dcbea98753addb1947"
      +checksum = "03c64931a1a212348ec4f3b4362585eca7159d0d09cbdf4a7f74f02173596fd4"
       dependencies = [
        "base64",
       ]
       
       [[package]]
       name = "percent-encoding"
      -version = "2.1.0"
      +version = "2.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d4fd5641d01c8f18a23da7b6fe29298ff4b55afcccdf78973b24cf3175fee32e"
      +checksum = "478c572c3d73181ff3c2539045f6eb99e5491218eae919370993b890cdbdd98e"
       
       [[package]]
       name = "pin-project"
      -version = "1.0.10"
      +version = "1.0.12"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "58ad3879ad3baf4e44784bc6a718a8698867bb991f8ce24d1bcbe2cfb4c3a75e"
      +checksum = "ad29a609b6bcd67fee905812e544992d216af9d755757c05ed2d0e15a74c6ecc"
       dependencies = [
        "pin-project-internal",
       ]
       
       [[package]]
       name = "pin-project-internal"
      -version = "1.0.10"
      +version = "1.0.12"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "744b6f092ba29c3650faf274db506afd39944f48420f6c86b17cfe0ee1cb36bb"
      +checksum = "069bdb1e05adc7a8990dce9cc75370895fbe4e3d58b9b73bf1aee56359344a55"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -1440,32 +1456,43 @@ version = "0.1.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "8b870d8c151b6f2fb93e84a13146138f05d02ed11c7e7c54f8826aaaf7c9f184"
       
      +[[package]]
      +name = "ping"
      +version = "0.4.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "69044d1c00894fc1f43d9485aadb6ab6e68df90608fa52cf1074cda6420c6b76"
      +dependencies = [
      + "rand",
      + "socket2 0.4.7",
      + "thiserror",
      +]
      +
       [[package]]
       name = "pkg-config"
      -version = "0.3.25"
      +version = "0.3.26"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1df8c4ec4b0627e53bdf214615ad287367e482558cf84b109250b37464dc03ae"
      +checksum = "6ac9a59f73473f1b8d852421e59e64809f025994837ef743615c6d0c5b305160"
       
       [[package]]
       name = "ppv-lite86"
      -version = "0.2.16"
      +version = "0.2.17"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "eb9f9e6e233e5c4a35559a617bf40a4ec447db2e84c20b55a6f83167b7e57872"
      +checksum = "5b40af805b3121feab8a3c29f04d8ad262fa8e0561883e7653e024ae4479e6de"
       
       [[package]]
       name = "proc-macro2"
      -version = "1.0.38"
      +version = "1.0.47"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9027b48e9d4c9175fa2218adf3557f91c1137021739951d4932f5f8268ac48aa"
      +checksum = "5ea3d908b0e36316caf9e9e2c4625cdde190a7e6f440d794667ed17a1855e725"
       dependencies = [
      - "unicode-xid",
      + "unicode-ident",
       ]
       
       [[package]]
       name = "protobuf"
      -version = "3.1.0"
      +version = "3.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "4ee4a7d8b91800c8f167a6268d1a1026607368e1adc84e98fe044aeb905302f7"
      +checksum = "b55bad9126f378a853655831eb7363b7b01b81d19f8cb1218861086ca4a1a61e"
       dependencies = [
        "bytes",
        "once_cell",
      @@ -1475,9 +1502,9 @@ dependencies = [
       
       [[package]]
       name = "protobuf-codegen"
      -version = "3.1.0"
      +version = "3.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "07b893e5e7d3395545d5244f8c0d33674025bd566b26c03bfda49b82c6dec45e"
      +checksum = "0dd418ac3c91caa4032d37cb80ff0d44e2ebe637b2fb243b6234bf89cdac4901"
       dependencies = [
        "anyhow",
        "once_cell",
      @@ -1490,9 +1517,9 @@ dependencies = [
       
       [[package]]
       name = "protobuf-parse"
      -version = "3.1.0"
      +version = "3.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9b1447dd751c434cc1b415579837ebd0411ed7d67d465f38010da5d7cd33af4d"
      +checksum = "9d39b14605eaa1f6a340aec7f320b34064feb26c93aec35d6a9a2272a8ddfa49"
       dependencies = [
        "anyhow",
        "indexmap",
      @@ -1506,9 +1533,9 @@ dependencies = [
       
       [[package]]
       name = "protobuf-support"
      -version = "3.1.0"
      +version = "3.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "8ca157fe12fc7ee2e315f2f735e27df41b3d97cdd70ea112824dac1ffb08ee1c"
      +checksum = "a5d4d7b8601c814cfb36bcebb79f0e61e45e1e93640cf778837833bbed05c372"
       dependencies = [
        "thiserror",
       ]
      @@ -1519,20 +1546,11 @@ version = "0.4.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "e9e1dcb320d6839f6edb64f7a4a59d39b30480d4d1765b56873f7c858538a5fe"
       
      -[[package]]
      -name = "quickcheck"
      -version = "1.0.3"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "588f6378e4dd99458b60ec275b4477add41ce4fa9f64dcba6f15adccb19b50d6"
      -dependencies = [
      - "rand",
      -]
      -
       [[package]]
       name = "quinn"
      -version = "0.8.2"
      +version = "0.8.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d147472bc9a09f13b06c044787b6683cdffa02e2865b7f0fb53d67c49ed2988e"
      +checksum = "5b435e71d9bfa0d8889927231970c51fb89c58fa63bffcab117c9c7a41e5ef8f"
       dependencies = [
        "bytes",
        "futures-channel",
      @@ -1549,9 +1567,9 @@ dependencies = [
       
       [[package]]
       name = "quinn-proto"
      -version = "0.8.2"
      +version = "0.8.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "359c5eb33845f3ee05c229e65f87cdbc503eea394964b8f1330833d460b4ff3e"
      +checksum = "3fce546b9688f767a57530652488420d419a8b1f44a478b451c3d1ab6d992a55"
       dependencies = [
        "bytes",
        "fxhash",
      @@ -1569,24 +1587,23 @@ dependencies = [
       
       [[package]]
       name = "quinn-udp"
      -version = "0.1.1"
      +version = "0.1.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "df185e5e5f7611fa6e628ed8f9633df10114b03bbaecab186ec55822c44ac727"
      +checksum = "b07946277141531aea269befd949ed16b2c85a780ba1043244eda0969e538e54"
       dependencies = [
        "futures-util",
        "libc",
      - "mio 0.7.14",
        "quinn-proto",
      - "socket2 0.4.4",
      + "socket2 0.4.7",
        "tokio",
        "tracing",
       ]
       
       [[package]]
       name = "quote"
      -version = "1.0.18"
      +version = "1.0.21"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "a1feb54ed693b93a84e14094943b84b7c4eae204c512b7ccb95ab0c66d278ad1"
      +checksum = "bbe448f377a7d6961e30f5955f9b8d106c3f5e449d493ee1b125c1d43c2b5179"
       dependencies = [
        "proc-macro2",
       ]
      @@ -1614,18 +1631,18 @@ dependencies = [
       
       [[package]]
       name = "rand_core"
      -version = "0.6.3"
      +version = "0.6.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d34f1408f55294453790c48b2f1ebbb1c5b4b7563eb1f418bcfcfdbb06ebb4e7"
      +checksum = "ec0be4795e2f6a28069bec0b5ff3e2ac9bafc99e6a9a7dc3547996c5c816922c"
       dependencies = [
        "getrandom",
       ]
       
       [[package]]
       name = "redox_syscall"
      -version = "0.2.13"
      +version = "0.2.16"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "62f25bc4c7e55e0b0b7a1d43fb893f4fa1361d0abe38b9ce4f323c2adfe6ef42"
      +checksum = "fb5a58c1855b4b6819d59012155603f0b22ad30cad752600aadfcb695265519a"
       dependencies = [
        "bitflags",
       ]
      @@ -1643,9 +1660,9 @@ dependencies = [
       
       [[package]]
       name = "regex"
      -version = "1.5.5"
      +version = "1.7.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1a11647b6b25ff05a515cb92c365cec08801e83423a235b51e231e1808747286"
      +checksum = "e076559ef8e241f2ae3479e36f97bd5741c0330689e217ad51ce2c76808b868a"
       dependencies = [
        "aho-corasick",
        "memchr",
      @@ -1654,9 +1671,9 @@ dependencies = [
       
       [[package]]
       name = "regex-syntax"
      -version = "0.6.25"
      +version = "0.6.28"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f497285884f3fcff424ffc933e56d7cbca511def0c9831a7f9b5f6153e3cc89b"
      +checksum = "456c603be3e8d448b072f410900c09faf164fbce2d480456f50eea6e25f9c848"
       
       [[package]]
       name = "remove_dir_all"
      @@ -1694,9 +1711,9 @@ dependencies = [
       
       [[package]]
       name = "rustls"
      -version = "0.20.4"
      +version = "0.20.7"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "4fbfeb8d0ddb84706bc597a5574ab8912817c52a397f819e5b614e2265206921"
      +checksum = "539a2bfe908f471bfa933876bd1eb6a19cf2176d375f82ef7f99530a40e48c2c"
       dependencies = [
        "log",
        "ring",
      @@ -1711,7 +1728,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "0167bac7a9f490495f3c33013e7722b53cb087ecbe082fb0c6387c96f634ea50"
       dependencies = [
        "openssl-probe",
      - "rustls-pemfile 1.0.0",
      + "rustls-pemfile 1.0.1",
        "schannel",
        "security-framework",
       ]
      @@ -1727,24 +1744,24 @@ dependencies = [
       
       [[package]]
       name = "rustls-pemfile"
      -version = "1.0.0"
      +version = "1.0.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "e7522c9de787ff061458fe9a829dc790a3f5b22dc571694fc5883f448b94d9a9"
      +checksum = "0864aeff53f8c05aa08d86e5ef839d3dfcf07aeba2db32f12db0ef716e87bd55"
       dependencies = [
        "base64",
       ]
       
       [[package]]
       name = "rustversion"
      -version = "1.0.6"
      +version = "1.0.9"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f2cc38e8fa666e2de3c4aba7edeb5ffc5246c1c2ed0e3d17e560aeeba736b23f"
      +checksum = "97477e48b4cf8603ad5f7aaf897467cf42ab4218a38ef76fb14c2d6773a6d6a8"
       
       [[package]]
       name = "ryu"
      -version = "1.0.9"
      +version = "1.0.11"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "73b4b750c782965c211b42f022f59af1fbceabdd026623714f104152f1ec149f"
      +checksum = "4501abdff3ae82a1c1b477a17252eb69cee9e66eb915c1abaa4f44d873df9f09"
       
       [[package]]
       name = "same-file"
      @@ -1757,12 +1774,12 @@ dependencies = [
       
       [[package]]
       name = "schannel"
      -version = "0.1.19"
      +version = "0.1.20"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "8f05ba609c234e60bee0d547fe94a4c7e9da733d1c962cf6e59efa4cd9c8bc75"
      +checksum = "88d6731146462ea25d9244b2ed5fd1d716d25c52e4d54aa4fb0f3c4e9854dbe2"
       dependencies = [
        "lazy_static",
      - "winapi",
      + "windows-sys 0.36.1",
       ]
       
       [[package]]
      @@ -1771,6 +1788,12 @@ version = "1.1.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd"
       
      +[[package]]
      +name = "scratch"
      +version = "1.0.2"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "9c8132065adcfd6e02db789d9285a0deb2f3fcb04002865ab67d5fb103533898"
      +
       [[package]]
       name = "sct"
       version = "0.7.0"
      @@ -1783,9 +1806,9 @@ dependencies = [
       
       [[package]]
       name = "security-framework"
      -version = "2.6.1"
      +version = "2.7.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "2dc14f172faf8a0194a3aded622712b0de276821addc574fa54fc0a1167e10dc"
      +checksum = "2bc1bb97804af6631813c55739f771071e0f2ed33ee20b68c86ec505d906356c"
       dependencies = [
        "bitflags",
        "core-foundation",
      @@ -1806,18 +1829,18 @@ dependencies = [
       
       [[package]]
       name = "serde"
      -version = "1.0.137"
      +version = "1.0.148"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "61ea8d54c77f8315140a05f4c7237403bf38b72704d031543aa1d16abbf517d1"
      +checksum = "e53f64bb4ba0191d6d0676e1b141ca55047d83b74f5607e6d8eb88126c52c2dc"
       dependencies = [
        "serde_derive",
       ]
       
       [[package]]
       name = "serde_derive"
      -version = "1.0.137"
      +version = "1.0.148"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1f26faba0c3959972377d3b2d306ee9f71faee9714294e41bb777f83f88578be"
      +checksum = "a55492425aa53521babf6137309e7d34c20bbfbbfcfe2c7f3a047fd1f6b92c0c"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -1826,9 +1849,9 @@ dependencies = [
       
       [[package]]
       name = "serde_json"
      -version = "1.0.81"
      +version = "1.0.89"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9b7ce2b32a1aed03c558dc61a5cd328f15aff2dbc17daad8fb8af04d2100e15c"
      +checksum = "020ff22c755c2ed3f8cf162dbb41a7268d934702f3ed3631656ea597e08fc3db"
       dependencies = [
        "itoa",
        "ryu",
      @@ -1849,9 +1872,20 @@ dependencies = [
       
       [[package]]
       name = "sha-1"
      -version = "0.10.0"
      +version = "0.10.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "028f48d513f9678cda28f6e4064755b3fbb2af6acd672f2c209b62323f7aea0f"
      +checksum = "f5058ada175748e33390e40e872bd0fe59a19f265d0158daa551c5a88a76009c"
      +dependencies = [
      + "cfg-if",
      + "cpufeatures",
      + "digest",
      +]
      +
      +[[package]]
      +name = "sha1"
      +version = "0.10.5"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "f04293dc80c3993519f2d7f6f511707ee7094fe0c6d3406feb330cdb3540eba3"
       dependencies = [
        "cfg-if",
        "cpufeatures",
      @@ -1860,9 +1894,9 @@ dependencies = [
       
       [[package]]
       name = "sha2"
      -version = "0.10.2"
      +version = "0.10.6"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "55deaec60f81eefe3cce0dc50bda92d6d8e88f2a27df7c5033b42afeb1ed2676"
      +checksum = "82e6b795fe2e3b1e845bafcb27aa35405c4d47cdfc92af5fc8d3002f76cebdc0"
       dependencies = [
        "cfg-if",
        "cpufeatures",
      @@ -1880,15 +1914,15 @@ dependencies = [
       
       [[package]]
       name = "signature"
      -version = "1.5.0"
      +version = "1.6.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f054c6c1a6e95179d6f23ed974060dcefb2d9388bb7256900badad682c499de4"
      +checksum = "74233d3b3b2f6d4b006dc19dee745e73e2a6bfb6f93607cd3b02bd5b00797d7c"
       
       [[package]]
       name = "simple_asn1"
      -version = "0.6.1"
      +version = "0.6.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "4a762b1c38b9b990c694b9c2f8abe3372ce6a9ceaae6bca39cfc46e054f45745"
      +checksum = "adc4e5204eb1910f40f9cfa375f6f05b68c3abac4b6fd879c8ff5e7ae8a0a085"
       dependencies = [
        "num-bigint",
        "num-traits",
      @@ -1898,15 +1932,18 @@ dependencies = [
       
       [[package]]
       name = "slab"
      -version = "0.4.6"
      +version = "0.4.7"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "eb703cfe953bccee95685111adeedb76fabe4e97549a58d16f03ea7b9367bb32"
      +checksum = "4614a76b2a8be0058caa9dbbaf66d988527d86d003c11a94fbd335d7661edcef"
      +dependencies = [
      + "autocfg",
      +]
       
       [[package]]
       name = "smallvec"
      -version = "1.8.0"
      +version = "1.10.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f2dd574626839106c320a323308629dcb1acfc96e32a8cba364ddc61ac23ee83"
      +checksum = "a507befe795404456341dfab10cef66ead4c041f62b8b11bbb92bffe5d0953e0"
       
       [[package]]
       name = "socket2"
      @@ -1921,9 +1958,9 @@ dependencies = [
       
       [[package]]
       name = "socket2"
      -version = "0.4.4"
      +version = "0.4.7"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "66d72b759436ae32898a2af0a14218dbf55efde3feeb170eb623637db85ee1e0"
      +checksum = "02e2d2db9033d13a1567121ddd7a095ee144db4e1ca1b1bda3419bc0da294ebd"
       dependencies = [
        "libc",
        "winapi",
      @@ -1949,18 +1986,18 @@ checksum = "6e63cff320ae2c57904679ba7cb63280a3dc4613885beafb148ee7bf9aa9042d"
       
       [[package]]
       name = "spin"
      -version = "0.9.3"
      +version = "0.9.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "c530c2b0d0bf8b69304b39fe2001993e267461948b890cd037d8ad4293fa1a0d"
      +checksum = "7f6002a767bff9e83f8eeecf883ecb8011875a21ae8da43bffb817a57e78cc09"
       dependencies = [
        "lock_api",
       ]
       
       [[package]]
       name = "sqlformat"
      -version = "0.1.8"
      +version = "0.2.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "b4b7922be017ee70900be125523f38bdd644f4f06a1b16e8fa5a8ee8c34bffd4"
      +checksum = "f87e292b4291f154971a43c3774364e2cbcaec599d3f5bf6fa9d122885dbc38a"
       dependencies = [
        "itertools",
        "nom 7.1.1",
      @@ -1969,9 +2006,9 @@ dependencies = [
       
       [[package]]
       name = "sqlx"
      -version = "0.6.0"
      +version = "0.6.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "1f82cbe94f41641d6c410ded25bbf5097c240cefdf8e3b06d04198d0a96af6a4"
      +checksum = "9249290c05928352f71c077cc44a464d880c63f26f7534728cca008e135c0428"
       dependencies = [
        "sqlx-core",
        "sqlx-macros",
      @@ -1979,9 +2016,9 @@ dependencies = [
       
       [[package]]
       name = "sqlx-core"
      -version = "0.6.0"
      +version = "0.6.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "6b69bf218860335ddda60d6ce85ee39f6cf6e5630e300e19757d1de15886a093"
      +checksum = "dcbc16ddba161afc99e14d1713a453747a2b07fc097d2009f4c300ec99286105"
       dependencies = [
        "ahash",
        "atoi",
      @@ -1991,6 +2028,7 @@ dependencies = [
        "chrono",
        "crc",
        "crossbeam-queue",
      + "dotenvy",
        "either",
        "event-listener",
        "flume",
      @@ -2011,7 +2049,7 @@ dependencies = [
        "paste",
        "percent-encoding",
        "rustls",
      - "rustls-pemfile 1.0.0",
      + "rustls-pemfile 1.0.1",
        "serde",
        "serde_json",
        "sha2",
      @@ -2027,11 +2065,11 @@ dependencies = [
       
       [[package]]
       name = "sqlx-macros"
      -version = "0.6.0"
      +version = "0.6.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f40c63177cf23d356b159b60acd27c54af7423f1736988502e36bae9a712118f"
      +checksum = "b850fa514dc11f2ee85be9d055c512aa866746adfacd1cb42d867d68e6a5b0d9"
       dependencies = [
      - "dotenv",
      + "dotenvy",
        "either",
        "heck",
        "once_cell",
      @@ -2047,9 +2085,9 @@ dependencies = [
       
       [[package]]
       name = "sqlx-rt"
      -version = "0.6.0"
      +version = "0.6.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "874e93a365a598dc3dadb197565952cb143ae4aa716f7bcc933a8d836f6bf89f"
      +checksum = "24c5b2d25fa654cc5f841750b8e1cdedbe21189bf9a9382ee90bfa9dd3562396"
       dependencies = [
        "once_cell",
        "tokio",
      @@ -2080,13 +2118,13 @@ checksum = "8ea5119cdb4c55b55d432abb513a0429384878c15dde60cc77b1c99de1a95a6a"
       
       [[package]]
       name = "syn"
      -version = "1.0.93"
      +version = "1.0.105"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "04066589568b72ec65f42d65a1a52436e954b168773148893c020269563decf2"
      +checksum = "60b9b43d45702de4c839cb9b51d9f529c5dd26a4aff255b42b1ebc03e88ee908"
       dependencies = [
        "proc-macro2",
        "quote",
      - "unicode-xid",
      + "unicode-ident",
       ]
       
       [[package]]
      @@ -2129,18 +2167,18 @@ dependencies = [
       
       [[package]]
       name = "thiserror"
      -version = "1.0.31"
      +version = "1.0.37"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "bd829fe32373d27f76265620b5309d0340cb8550f523c1dda251d6298069069a"
      +checksum = "10deb33631e3c9018b9baf9dcbbc4f737320d2b576bac10f6aefa048fa407e3e"
       dependencies = [
        "thiserror-impl",
       ]
       
       [[package]]
       name = "thiserror-impl"
      -version = "1.0.31"
      +version = "1.0.37"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0396bc89e626244658bef819e22d0cc459e795a5ebe878e6ec336d1674a8d79a"
      +checksum = "982d17546b47146b28f7c22e3d08465f6b8903d0ea13c1660d9d84a6e7adcdbb"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -2149,11 +2187,12 @@ dependencies = [
       
       [[package]]
       name = "time"
      -version = "0.1.43"
      +version = "0.1.45"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "ca8a50ef2360fbd1eeb0ecd46795a87a19024eb4b53c5dc916ca1fd95fe62438"
      +checksum = "1b797afad3f312d1c66a56d11d0316f916356d11bd158fbc6ca6389ff6bf805a"
       dependencies = [
        "libc",
      + "wasi 0.10.0+wasi-snapshot-preview1",
        "winapi",
       ]
       
      @@ -2166,7 +2205,6 @@ dependencies = [
        "itoa",
        "libc",
        "num_threads",
      - "quickcheck",
        "time-macros",
       ]
       
      @@ -2193,30 +2231,29 @@ checksum = "cda74da7e1a664f795bb1f8a87ec406fb89a02522cf6e50620d016add6dbbf5c"
       
       [[package]]
       name = "tokio"
      -version = "1.20.0"
      +version = "1.22.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "57aec3cfa4c296db7255446efb4928a6be304b431a806216105542a67b6ca82e"
      +checksum = "d76ce4a75fb488c605c54bf610f221cea8b0dafb53333c1a67e8ee199dcd2ae3"
       dependencies = [
        "autocfg",
        "bytes",
        "libc",
        "memchr",
      - "mio 0.8.3",
      + "mio",
        "num_cpus",
      - "once_cell",
      - "parking_lot 0.12.0",
      + "parking_lot 0.12.1",
        "pin-project-lite",
        "signal-hook-registry",
      - "socket2 0.4.4",
      + "socket2 0.4.7",
        "tokio-macros",
        "winapi",
       ]
       
       [[package]]
       name = "tokio-macros"
      -version = "1.7.0"
      +version = "1.8.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "b557f72f448c511a979e2564e55d74e6c4432fc96ff4f6241bc6bded342643b7"
      +checksum = "d266c00fde287f55d3f1c3e96c500c362a2b8c695076ec180f27918820bc6df8"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -2236,8 +2273,8 @@ dependencies = [
       
       [[package]]
       name = "tokio-socks"
      -version = "0.5.1"
      -source = "git+https://github.com/open-trade/tokio-socks#3de8300fbce37e2cdaef042e016aa95058d007cf"
      +version = "0.5.1-1"
      +source = "git+https://github.com/open-trade/tokio-socks#7034e79263ce25c348be072808d7601d82cd892d"
       dependencies = [
        "bytes",
        "either",
      @@ -2247,14 +2284,14 @@ dependencies = [
        "pin-project",
        "thiserror",
        "tokio",
      - "tokio-util 0.6.9",
      + "tokio-util",
       ]
       
       [[package]]
       name = "tokio-stream"
      -version = "0.1.8"
      +version = "0.1.11"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "50145484efff8818b5ccd256697f36863f587da82cf8b409c53adf1e840798e3"
      +checksum = "d660770404473ccd7bc9f8b28494a811bc18542b915c0855c51e8f419d5223ce"
       dependencies = [
        "futures-core",
        "pin-project-lite",
      @@ -2263,9 +2300,9 @@ dependencies = [
       
       [[package]]
       name = "tokio-tungstenite"
      -version = "0.17.1"
      +version = "0.17.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "06cda1232a49558c46f8a504d5b93101d42c0bf7f911f12a105ba48168f821ae"
      +checksum = "f714dd15bead90401d77e04243611caec13726c2408afd5b31901dfcdcb3b181"
       dependencies = [
        "futures-util",
        "log",
      @@ -2275,29 +2312,16 @@ dependencies = [
       
       [[package]]
       name = "tokio-util"
      -version = "0.6.9"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9e99e1983e5d376cd8eb4b66604d2e99e79f5bd988c3055891dcd8c9e2604cc0"
      -dependencies = [
      - "bytes",
      - "futures-core",
      - "futures-sink",
      - "log",
      - "pin-project-lite",
      - "tokio",
      -]
      -
      -[[package]]
      -name = "tokio-util"
      -version = "0.7.1"
      +version = "0.7.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "0edfdeb067411dba2044da6d1cb2df793dd35add7888d73c16e3381ded401764"
      +checksum = "0bb2e075f03b3d66d8d8785356224ba688d2906a371015e225beeb65ca92c740"
       dependencies = [
        "bytes",
        "futures-core",
        "futures-io",
        "futures-sink",
        "futures-util",
      + "hashbrown",
        "pin-project-lite",
        "slab",
        "tokio",
      @@ -2315,16 +2339,15 @@ dependencies = [
       
       [[package]]
       name = "tower"
      -version = "0.4.12"
      +version = "0.4.13"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "9a89fd63ad6adf737582df5db40d286574513c69a11dac5214dc3b5603d6713e"
      +checksum = "b8fa9be0de6cf49e536ce1851f987bd21a43b771b09473c3549a6c853db37c1c"
       dependencies = [
        "futures-core",
        "futures-util",
        "pin-project",
        "pin-project-lite",
        "tokio",
      - "tokio-util 0.7.1",
        "tower-layer",
        "tower-service",
        "tracing",
      @@ -2332,9 +2355,9 @@ dependencies = [
       
       [[package]]
       name = "tower-http"
      -version = "0.3.3"
      +version = "0.3.4"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "7d342c6d58709c0a6d48d48dabbb62d4ef955cf5f0f3bbfd845838e7ae88dbae"
      +checksum = "3c530c8675c1dbf98facee631536fa116b5fb6382d7dd6dc1b118d970eafe3ba"
       dependencies = [
        "bitflags",
        "bytes",
      @@ -2349,7 +2372,7 @@ dependencies = [
        "percent-encoding",
        "pin-project-lite",
        "tokio",
      - "tokio-util 0.7.1",
      + "tokio-util",
        "tower",
        "tower-layer",
        "tower-service",
      @@ -2358,21 +2381,21 @@ dependencies = [
       
       [[package]]
       name = "tower-layer"
      -version = "0.3.1"
      +version = "0.3.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "343bc9466d3fe6b0f960ef45960509f84480bf4fd96f92901afe7ff3df9d3a62"
      +checksum = "c20c8dbed6283a09604c3e69b4b7eeb54e298b8a600d4d5ecb5ad39de609f1d0"
       
       [[package]]
       name = "tower-service"
      -version = "0.3.1"
      +version = "0.3.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "360dfd1d6d30e05fda32ace2c8c70e9c0a9da713275777f5a4dbb8a1893930c6"
      +checksum = "b6bc1c9ce2b5135ac7f93c72918fc37feb872bdc6a5533a8b85eb4b86bfdae52"
       
       [[package]]
       name = "tracing"
      -version = "0.1.34"
      +version = "0.1.37"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "5d0ecdcb44a79f0fe9844f0c4f33a342cbcbb5117de8001e6ba0dc2351327d09"
      +checksum = "8ce8c33a8d48bd45d624a6e523445fd21ec13d3653cd51f681abf67418f54eb8"
       dependencies = [
        "cfg-if",
        "log",
      @@ -2383,9 +2406,9 @@ dependencies = [
       
       [[package]]
       name = "tracing-attributes"
      -version = "0.1.21"
      +version = "0.1.23"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "cc6b8ad3567499f98a1db7a752b07a7c8c7c7c34c332ec00effb2b0027974b7c"
      +checksum = "4017f8f45139870ca7e672686113917c71c7a6e02d4924eda67186083c03081a"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -2394,11 +2417,11 @@ dependencies = [
       
       [[package]]
       name = "tracing-core"
      -version = "0.1.26"
      +version = "0.1.30"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f54c8ca710e81886d498c2fd3331b56c93aa248d49de2222ad2742247c60072f"
      +checksum = "24eb03ba0eab1fd845050058ce5e616558e8f8d8fca633e6b163fe25c797213a"
       dependencies = [
      - "lazy_static",
      + "once_cell",
       ]
       
       [[package]]
      @@ -2409,9 +2432,9 @@ checksum = "59547bce71d9c38b83d9c0e92b6066c4253371f15005def0c30d9657f50c7642"
       
       [[package]]
       name = "tungstenite"
      -version = "0.17.2"
      +version = "0.17.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d96a2dea40e7570482f28eb57afbe42d97551905da6a9400acc5c328d24004f5"
      +checksum = "e27992fd6a8c29ee7eef28fc78349aa244134e10ad447ce3b9f0ac0ed0fa4ce0"
       dependencies = [
        "base64",
        "byteorder",
      @@ -2447,32 +2470,32 @@ version = "0.3.8"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "099b7128301d285f79ddd55b9a83d5e6b9e97c92e0ea0daebee7263e932de992"
       
      +[[package]]
      +name = "unicode-ident"
      +version = "1.0.5"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "6ceab39d59e4c9499d4e5a8ee0e2735b891bb7308ac83dfb4e80cad195c9f6f3"
      +
       [[package]]
       name = "unicode-normalization"
      -version = "0.1.19"
      +version = "0.1.22"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d54590932941a9e9266f0832deed84ebe1bf2e4c9e4a3554d393d18f5e854bf9"
      +checksum = "5c5713f0fc4b5db668a2ac63cdb7bb4469d8c9fed047b1d0292cc7b0ce2ba921"
       dependencies = [
        "tinyvec",
       ]
       
       [[package]]
       name = "unicode-segmentation"
      -version = "1.9.0"
      +version = "1.10.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "7e8820f5d777f6224dc4be3632222971ac30164d4a258d595640799554ebfd99"
      +checksum = "0fdbf052a0783de01e944a6ce7a8cb939e295b1e7be835a1112c3b9a7f047a5a"
       
       [[package]]
       name = "unicode-width"
      -version = "0.1.9"
      -source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "3ed742d4ea2bd1176e236172c8429aaf54486e7ac098db29ffe6529e0ce50973"
      -
      -[[package]]
      -name = "unicode-xid"
      -version = "0.2.3"
      +version = "0.1.10"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "957e51f3646910546462e67d5f7599b9e4fb8acdd304b087a6494730f9eebf04"
      +checksum = "c0edd1e5b14653f783770bce4a4dabb4a5108a5370a5f5d8cfe8710c361f6c8b"
       
       [[package]]
       name = "unicode_categories"
      @@ -2488,13 +2511,12 @@ checksum = "a156c684c91ea7d62626509bce3cb4e1d9ed5c4d978f7b4352658f96a4c26b4a"
       
       [[package]]
       name = "url"
      -version = "2.2.2"
      +version = "2.3.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "a507c383b2d33b5fc35d1861e77e6b383d158b2da5e14fe51b83dfedf6fd578c"
      +checksum = "0d68c799ae75762b8c3fe375feb6600ef5602c883c5d21eb51c09f22b83c4643"
       dependencies = [
        "form_urlencoded",
        "idna",
      - "matches",
        "percent-encoding",
       ]
       
      @@ -2506,9 +2528,9 @@ checksum = "09cc8ee72d2a9becf2f2febe0205bbed8fc6615b7cb429ad062dc7b7ddd036a9"
       
       [[package]]
       name = "uuid"
      -version = "1.1.2"
      +version = "1.2.2"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "dd6469f4314d5f1ffec476e05f17cc9a78bc7a27a6a857842170bdf8d6f98d2f"
      +checksum = "422ee0de9031b5b948b97a8fc04e3aa35230001a722ddd27943e0be31564ce4c"
       dependencies = [
        "getrandom",
       ]
      @@ -2554,9 +2576,9 @@ dependencies = [
       
       [[package]]
       name = "wasi"
      -version = "0.10.2+wasi-snapshot-preview1"
      +version = "0.10.0+wasi-snapshot-preview1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "fd6fbd9a79829dd1ad0cc20627bf1ed606756a7f77edff7b66b7064f9cb327c6"
      +checksum = "1a143597ca7c7793eff794def352d41792a93c481eb1042423ff7ff72ba2c31f"
       
       [[package]]
       name = "wasi"
      @@ -2566,9 +2588,9 @@ checksum = "9c8d87e72b64a3b4db28d11ce29237c246188f4f51057d65a7eab63b7987e423"
       
       [[package]]
       name = "wasm-bindgen"
      -version = "0.2.80"
      +version = "0.2.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "27370197c907c55e3f1a9fbe26f44e937fe6451368324e009cba39e139dc08ad"
      +checksum = "eaf9f5aceeec8be17c128b2e93e031fb8a4d469bb9c4ae2d7dc1888b26887268"
       dependencies = [
        "cfg-if",
        "wasm-bindgen-macro",
      @@ -2576,13 +2598,13 @@ dependencies = [
       
       [[package]]
       name = "wasm-bindgen-backend"
      -version = "0.2.80"
      +version = "0.2.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "53e04185bfa3a779273da532f5025e33398409573f348985af9a1cbf3774d3f4"
      +checksum = "4c8ffb332579b0557b52d268b91feab8df3615f265d5270fec2a8c95b17c1142"
       dependencies = [
        "bumpalo",
      - "lazy_static",
        "log",
      + "once_cell",
        "proc-macro2",
        "quote",
        "syn",
      @@ -2591,9 +2613,9 @@ dependencies = [
       
       [[package]]
       name = "wasm-bindgen-macro"
      -version = "0.2.80"
      +version = "0.2.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "17cae7ff784d7e83a2fe7611cfe766ecf034111b49deb850a3dc7699c08251f5"
      +checksum = "052be0f94026e6cbc75cdefc9bae13fd6052cdcaf532fa6c45e7ae33a1e6c810"
       dependencies = [
        "quote",
        "wasm-bindgen-macro-support",
      @@ -2601,9 +2623,9 @@ dependencies = [
       
       [[package]]
       name = "wasm-bindgen-macro-support"
      -version = "0.2.80"
      +version = "0.2.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "99ec0dc7a4756fffc231aab1b9f2f578d23cd391390ab27f952ae0c9b3ece20b"
      +checksum = "07bc0c051dc5f23e307b13285f9d75df86bfdf816c5721e573dec1f9b8aa193c"
       dependencies = [
        "proc-macro2",
        "quote",
      @@ -2614,15 +2636,15 @@ dependencies = [
       
       [[package]]
       name = "wasm-bindgen-shared"
      -version = "0.2.80"
      +version = "0.2.83"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "d554b7f530dee5964d9a9468d95c1f8b8acae4f282807e7d27d4b03099a46744"
      +checksum = "1c38c045535d93ec4f0b4defec448e4291638ee608530863b1e2ba115d4fff7f"
       
       [[package]]
       name = "web-sys"
      -version = "0.3.57"
      +version = "0.3.60"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "7b17e741662c70c8bd24ac5c5b18de314a2c26c32bf8346ee1e6f53de919c283"
      +checksum = "bcda906d8be16e728fd5adc5b729afad4e444e106ab28cd1c7256e54fa61510f"
       dependencies = [
        "js-sys",
        "wasm-bindgen",
      @@ -2640,30 +2662,31 @@ dependencies = [
       
       [[package]]
       name = "webpki-roots"
      -version = "0.22.4"
      +version = "0.22.5"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "f1c760f0d366a6c24a02ed7816e23e691f5d92291f94d15e836006fd11b04daf"
      +checksum = "368bfe657969fb01238bb756d351dcade285e0f6fcbd36dcb23359a5169975be"
       dependencies = [
        "webpki",
       ]
       
       [[package]]
       name = "which"
      -version = "4.2.5"
      +version = "4.3.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "5c4fb54e6113b6a8772ee41c3404fb0301ac79604489467e0a9ce1f3e97c24ae"
      +checksum = "1c831fbbee9e129a8cf93e7747a82da9d95ba8e16621cae60ec2cdc849bacb7b"
       dependencies = [
        "either",
      - "lazy_static",
        "libc",
      + "once_cell",
       ]
       
       [[package]]
       name = "whoami"
      -version = "1.2.1"
      +version = "1.2.3"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "524b58fa5a20a2fb3014dd6358b70e6579692a56ef6fce928834e488f42f65e8"
      +checksum = "d6631b6a2fd59b1841b622e8f1a7ad241ef0a46f2d580464ce8140ac94cbd571"
       dependencies = [
      + "bumpalo",
        "wasm-bindgen",
        "web-sys",
       ]
      @@ -2700,29 +2723,39 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f"
       
       [[package]]
      -name = "windows"
      -version = "0.18.0"
      +name = "windows-sys"
      +version = "0.36.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "68088239696c06152844eadc03d262f088932cce50c67e4ace86e19d95e976fe"
      +checksum = "ea04155a16a59f9eab786fe12a4a450e75cdb175f9e0d80da1e17db09f55b8d2"
       dependencies = [
      - "const-sha1",
      - "windows_gen",
      - "windows_macros",
      + "windows_aarch64_msvc 0.36.1",
      + "windows_i686_gnu 0.36.1",
      + "windows_i686_msvc 0.36.1",
      + "windows_x86_64_gnu 0.36.1",
      + "windows_x86_64_msvc 0.36.1",
       ]
       
       [[package]]
       name = "windows-sys"
      -version = "0.36.1"
      +version = "0.42.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "ea04155a16a59f9eab786fe12a4a450e75cdb175f9e0d80da1e17db09f55b8d2"
      +checksum = "5a3e1820f08b8513f676f7ab6c1f99ff312fb97b553d30ff4dd86f9f15728aa7"
       dependencies = [
      - "windows_aarch64_msvc",
      - "windows_i686_gnu",
      - "windows_i686_msvc",
      - "windows_x86_64_gnu",
      - "windows_x86_64_msvc",
      + "windows_aarch64_gnullvm",
      + "windows_aarch64_msvc 0.42.0",
      + "windows_i686_gnu 0.42.0",
      + "windows_i686_msvc 0.42.0",
      + "windows_x86_64_gnu 0.42.0",
      + "windows_x86_64_gnullvm",
      + "windows_x86_64_msvc 0.42.0",
       ]
       
      +[[package]]
      +name = "windows_aarch64_gnullvm"
      +version = "0.42.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "41d2aa71f6f0cbe00ae5167d90ef3cfe66527d6f613ca78ac8024c3ccab9a19e"
      +
       [[package]]
       name = "windows_aarch64_msvc"
       version = "0.36.1"
      @@ -2730,10 +2763,10 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "9bb8c3fd39ade2d67e9874ac4f3db21f0d710bee00fe7cab16949ec184eeaa47"
       
       [[package]]
      -name = "windows_gen"
      -version = "0.18.0"
      +name = "windows_aarch64_msvc"
      +version = "0.42.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "cf583322dc423ee021035b358e535015f7fd163058a31e2d37b99a939141121d"
      +checksum = "dd0f252f5a35cac83d6311b2e795981f5ee6e67eb1f9a7f64eb4500fbc4dcdb4"
       
       [[package]]
       name = "windows_i686_gnu"
      @@ -2741,6 +2774,12 @@ version = "0.36.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "180e6ccf01daf4c426b846dfc66db1fc518f074baa793aa7d9b9aaeffad6a3b6"
       
      +[[package]]
      +name = "windows_i686_gnu"
      +version = "0.42.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "fbeae19f6716841636c28d695375df17562ca208b2b7d0dc47635a50ae6c5de7"
      +
       [[package]]
       name = "windows_i686_msvc"
       version = "0.36.1"
      @@ -2748,14 +2787,10 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "e2e7917148b2812d1eeafaeb22a97e4813dfa60a3f8f78ebe204bcc88f12f024"
       
       [[package]]
      -name = "windows_macros"
      -version = "0.18.0"
      +name = "windows_i686_msvc"
      +version = "0.42.0"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "58acfb8832e9f707f8997bd161e537a1c1f603e60a5bd9c3cf53484fdcc998f3"
      -dependencies = [
      - "syn",
      - "windows_gen",
      -]
      +checksum = "84c12f65daa39dd2babe6e442988fc329d6243fdce47d7d2d155b8d874862246"
       
       [[package]]
       name = "windows_x86_64_gnu"
      @@ -2763,12 +2798,30 @@ version = "0.36.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "4dcd171b8776c41b97521e5da127a2d86ad280114807d0b2ab1e462bc764d9e1"
       
      +[[package]]
      +name = "windows_x86_64_gnu"
      +version = "0.42.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "bf7b1b21b5362cbc318f686150e5bcea75ecedc74dd157d874d754a2ca44b0ed"
      +
      +[[package]]
      +name = "windows_x86_64_gnullvm"
      +version = "0.42.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "09d525d2ba30eeb3297665bd434a54297e4170c7f1a44cad4ef58095b4cd2028"
      +
       [[package]]
       name = "windows_x86_64_msvc"
       version = "0.36.1"
       source = "registry+https://github.com/rust-lang/crates.io-index"
       checksum = "c811ca4a8c853ef420abd8592ba53ddbbac90410fab6903b3e79972a631f7680"
       
      +[[package]]
      +name = "windows_x86_64_msvc"
      +version = "0.42.0"
      +source = "registry+https://github.com/rust-lang/crates.io-index"
      +checksum = "f40009d85759725a34da6d89a94e63d7bdc50a862acf0dbc7c8e488f1edcb6f5"
      +
       [[package]]
       name = "winreg"
       version = "0.6.2"
      @@ -2780,9 +2833,9 @@ dependencies = [
       
       [[package]]
       name = "zeroize"
      -version = "1.5.5"
      +version = "1.5.7"
       source = "registry+https://github.com/rust-lang/crates.io-index"
      -checksum = "94693807d016b2f2d2e14420eb3bfcca689311ff775dcf113d74ea624b7cdf07"
      +checksum = "c394b5bd0c6f669e7275d9c20aa90ae064cb22e75a1cad54e1b34088034b149f"
       
       [[package]]
       name = "zstd"
      diff --git a/Cargo.toml b/Cargo.toml
      index 8d51a11..3b76a72 100644
      --- a/Cargo.toml
      +++ b/Cargo.toml
      @@ -57,3 +57,6 @@ hbb_common = { path = "libs/hbb_common" }
       
       [workspace]
       members = ["libs/hbb_common"]
      +
      +[patch."https://github.com/open-trade/async-speed-limit"]
      +async-speed-limit = { path = "${generated.async-speed-limit-tokio1.src}" }
    '')
  ];
  cargoHash = "sha256-FV0OGTj/lgWmf66Lc5txxV0FoJ7EOhPViMn4uG7+6kQ=";

  meta = {
    description = "RustDesk Server Program";
    homepage = "https://github.com/rustdesk/rustdesk-server";
    license = lib.licenses.agpl3;
  };
}
