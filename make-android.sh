#!/bin/bash

NATIVEDIR=$(dirname "$0")

pushd "$NATIVEDIR/lib/theora/arm" > /dev/null

for armopts in armopts-*.s.in; do
    type="${armopts}"
    type="${type##armopts-}"
    type="${type%.s.in}"
    echo "Generating .S files for type $type using $armopts"

    for src in arm*.s; do
        if [[ "$src" =~ ^armopts.* ]]; then
            continue
        fi

        out="${src%.*}-$type.gen.S"
        echo "$src + $armopts = $out"
        TYPESUFFIX=$type ./arm2gnu.pl < $src > $out
    done

    out="armopts-${type}.gen.S"
    echo "$armopts = $out"
    TYPESUFFIX=$type ./arm2gnu.pl < $armopts > $out
done

popd > /dev/null

ndk-build -j 4 NDK_PROJECT_PATH="$NATIVEDIR/" NDK_APPLICATION_MK="$NATIVEDIR/Application.mk" $@
