# `posts` is a build target, but also a location in our build tree, so we'd
# better mark it as phony. `all` and `clean` are also marked, but more out of a,
# possibly, cargo-cultish habit.
.PHONY: all clean posts

# Default action. Build everything.
all: posts

# All the output is contained in a single directory, so cleaning is as simple as
# deleting that directory and all its contents.
clean:
	rm --recursive --force site/

# These are the markdown versions of the posts.
POST_SRC_FILES := $(wildcard posts/*.md)

# These are the html versions of the posts.
POST_DST_FILES := $(patsubst posts/%.md, site/%/index.html, $(POST_SRC_FILES))

# Post building instructions.
$(POST_DST_FILES) : site/%/index.html : posts/%.md
	mkdir --parents $(dir $@)
	markdown $< > $@

# Target to build the posts.
posts: $(POST_DST_FILES)
