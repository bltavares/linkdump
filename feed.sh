#!/usr/bin/env bash

file=${1:-atom.xml}
title="Link Dump"
base_url="http://linkdump.bltavares.com/"

entries() {
    for file in archive/*.org; do
        IFS='|' read hash author date < <(git show --format='%H|%an|%aI' -s $file)
        content="$(git show $hash:$file)"
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
		<content>
        <![CDATA[
            ${content}
        ]]>
		</content>
	</entry>
EOF
    done
}

last_update() {
    git show --format='%aI' -s archive
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
