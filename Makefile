# `assets` and `posts` are build targets, but also locations in our tree, so
# better mark as phony. `all` and `clean` are also marked, but more out of a,
# possibly, cargo-cultish habit.
.PHONY: all clean assets posts

# Default action. Build everything.
all: assets posts

# All the output is contained in a single directory, so cleaning is as simple as
# deleting that directory and all its contents. We should also delete our
# temporary build directory too.
clean:
	rm --recursive --force site/
	rm --recursive --force build/

# Making our assets target is as simple as creating the directory to hold the
# assets, then copying them in to place.
site/assets/:
	mkdir --parents site/assets/
	cp --recursive ./assets/* site/assets/

# A 'shortcut' target that's nicer to type than the full directory name.
assets: site/assets/

# These are the markdown versions of the posts.
POST_SRC_FILES := $(wildcard posts/*.md)

# These are the html versions of the posts. This and the `%` wildcard in the
# static pattern rule below, allow for 'pretty-urls' like `/test-post` instead
# of `/test-post.html`.
POST_DST_FILES := $(patsubst posts/%.md, site/%/index.html, $(POST_SRC_FILES))

# Post building instructions.
$(POST_DST_FILES) : site/%/index.html : posts/%.md
	@# Make the directory for the pretty-print URL.
	mkdir --parents $(dir $@)

	@# Make the directory for the temporary build files.
	mkdir --parents build/$<

	@# Split the markdown file into the frontmatter and contents.
	csplit --silent --elide-empty-files --prefix=build/$</ --digits=1 $< '/^---$$/' '{*}'

	@# Parse and render the frontmatter into the page's header.
	tail -n+2 build/$</0 | templates/post.head.html > build/$</head.html

	@# Render the markdown into the page's body.
	tail -n+2 build/$</1 | markdown | templates/post.body.html > build/$</body.html

	@# Concatenate the two parts in to the final file.
	cat build/$</head.html build/$</body.html > $@

# Target to build the posts.
posts: $(POST_DST_FILES)

# Include any extra make commands or helpers we have.
include extras/**/*.mk
