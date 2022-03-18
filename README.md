# Terrain

A procedurally generated 3d terrain renderer written in Flutter.

## Plan

More generalised classes than the one's written in Subdivide. For example, by storing vertex
normals, there won't be any assumptions made to calculate them later.

I'm also planning to subdivide the triangles properly, using the surround vertices to calculate the
new height. This will be easier to visualise when making a bumpy terrain, hence the reason for this
project. Though it will yield a terrain, this will also form the basic code for rendering any simple
mesh.

I'm not planning on anything fancy like level of detail or texturing based on slope angle (though I
might be tempted), just a simple mesh renderer.

### TODO

Draw a grid Store vertex normals

Subdivide the heights too. See if using an average of local vertices is enough rather than a spline.

Use vertex index list No duplicate vertices.

By animating the light rather than the transform, see if there's a way of making Triangles more
const - by not changing there vertices, just the colors that they are painted.