#!/usr/bin/env bash

_deobfuscate() {
    echo "$1" | rev | tr -d '@'
}

# These can be extracted trivially from the app, so there is no point in trying to hide them.
# Obfuscate them slightly in the flatpak manifest to prevent bots from easily scraping them.
export "$(_deobfuscate "D@I@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "7@7@d@d@4@c@1@e@3@7@9@9@e@7@c@3@e@0@e@d@")"
export "$(_deobfuscate "T@E@R@C@E@S@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "3@a@2@e@1@6@9@d@9@a@4@2@a@b@8@4@9@1@1@9@2@a@c@2@c@7@3@7@2@c@f@5@a@5@0@3@3@7@2@1@")"
export "$(_deobfuscate "T@E@K@C@U@B@T@I@B@_@D@I@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "3@3@y@P@z@p@Y@f@M@R@p@J@R@3@P@c@X@v@")"
export "$(_deobfuscate "T@E@K@C@U@B@T@I@B@_@T@E@R@C@E@S@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "v@B@n@D@g@L@7@m@g@q@w@D@L@j@N@K@f@2@M@z@g@Q@F@u@E@x@H@w@Z@N@t@Y@")"
export "$(_deobfuscate "B@A@L@T@I@G@_@D@I@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "a@7@4@a@6@e@e@1@e@e@7@d@c@6@1@f@c@c@f@0@a@f@8@8@c@b@f@2@8@8@f@2@6@c@0@0@2@f@f@7@c@9@c@5@d@9@2@8@d@b@9@f@c@0@3@8@b@9@d@c@5@9@8@5@")"
export "$(_deobfuscate "B@A@L@T@I@G@_@T@E@R@C@E@S@_@T@N@E@I@L@C@_@H@T@U@A@O@_@P@O@T@K@S@E@D@")"="$(_deobfuscate "2@d@1@0@8@c@d@a@4@4@1@c@6@9@8@a@1@b@2@9@b@5@b@a@0@c@6@a@1@c@c@8@1@c@6@c@0@2@6@c@4@8@c@6@7@7@b@3@2@f@6@e@e@6@6@6@a@b@a@8@b@f@2@3@-@s@a@o@l@g@")"
