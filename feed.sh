#!/usr/bin/env bash

file=${1:-atom.xml}
title="Link Dump"
base_url="http://linkdump.bltavares.com/"

entries() {
    for src in archive/*.org; do
        file="${src%.org}.html"
        git_info="$(git log -n1 --format='%H|%an|%aD' -- "$file")"
        IFS='|' read hash author date <<<"$git_info"
        content="$(git show $hash:$file | awk '/<body>/{ p=1; next } /<\/body>/{p=0} p')"
        title=$(grep 'h1' <<<"$content" | grep 'title' | cut -d'>' -f2 | cut -d'<' -f1)

        cat <<EOF
	<entry>
		<title>${title}</title>
		<link href="${base_url}${file}" />
		<link rel="alternate" type="text/plain" href="${base_url}${src}"/>
		<id>${base_url}${file}</id>
		<updated>${date}</updated>
		<author>
			<name>${author}</name>
		</author>
		<content xml:space="preserve" type="html">
        <![CDATA[
            ${content}
        ]]>
		</content>
	</entry>
EOF
    done
}

last_update() {
    git log -n1 --format='%aD' -- archive
}

cat > $file <<EOF
<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
 
	<title>${title}</title>
	<link href="${base_url}atom.xml" rel="self" />
	<link href="${base_url}" />
	<id>${base_url}</id>
	<updated>$(last_update)</updated>

  $(entries)

</feed>
EOF
