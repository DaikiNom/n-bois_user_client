# N-BOIS
## Detail
N-BOIS is an app that allows you know current information about the bus of [Nishogakusha University Kashiwa Junior / Senior High School](https://www.nishogakusha-kashiwa.ed.jp/).

## How to build
1. Run this command in order to install packages.
    ```bash
    flutter pub get
    ```
2. Make `.env` file and edit the file like this.
    ```text
    SUPABASE_URL = [Supabase project's url]
    SUPABASE_ANONKEY = [Supabase project's anon key]
    ```
3. Make `lib/env/env.dart` and edit the file like this.
    ```dart
    import 'package:envied/envied.dart';
    part 'env.g.dart';
    
    @Envied(path: '.env')
    abstract class Env {
      @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
      static String SupabaseUrl = _Env.SupabaseUrl;
    
      @EnviedField(varName: 'SUPABASE_ANONKEY', obfuscate: true)
      static String SupabaseAnonKey = _Env.SupabaseAnonKey;
    }
    ```
4. Run this command.
    ```bash
    dart run build_runner build
    ```

## License
This app is licensed by AGPL-3.0.  
Copyright (c) [DaikiNomura](https://daikinomura.tech)

If you have any idea about developing this app or find some bugs, please send an e-mail to [this e-mail address](mailto:contact@daikinomura.tech)
