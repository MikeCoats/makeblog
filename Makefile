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

# These are the posts we want to transform.
posts: site/test-post-1/index.html site/test-post-2/index.html

# Transform one post from Markdown to HTML
site/test-post-1/index.html : posts/test-post-1.md
	mkdir --parents site/test-post-1
	markdown $< > $@

# Transform a second post from Markdown to HTML
site/test-post-2/index.html : posts/test-post-2.md
	mkdir --parents site/test-post-2
	markdown $< > $@
