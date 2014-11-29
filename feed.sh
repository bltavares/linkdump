#!/usr/bin/env bash

file=${1:-atom.xml}
title="Link Dump"
base_url="http://linkdump.bltavares.com/"

entries() {
    for file in archive/*.org; do
        git_info="$(git log -n1 --format='%H|%an|%aI' -- "$file")"
        IFS='|' read hash author date <<<"$git_info"
        content="$(git show $hash:$file | awk 1 ORS='&#10;\n')"
        title=$(grep "Title" <<<"$content" | cut -d: -f2)

        cat <<EOF
	<entry>
		<title>${title}</title>
		<link href="${base_url}${file}" />
		<link rel="alternate" type="text/html" href="${base_url}${file%.org}.html"/>
		<id>${base_url}${file}</id>
		<updated>${date}</updated>
		<author>
			<name>${author}</name>
		</author>
		<content xml:space="preserve" type="text">
        <![CDATA[
            ${content}
        ]]>
		</content>
	</entry>
EOF
    done
}

last_update() {
    git log -n1 --format='%aI' -- archive
}

cat > $file <<EOF
<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
 
	<title>${title}</title>
	<link href="${base_url}feed.atom" rel="self" />
	<link href="${base_url}" />
	<id>${base_url}</id>
	<updated>$(last_update)</updated>

  $(entries)

</feed>
EOF
