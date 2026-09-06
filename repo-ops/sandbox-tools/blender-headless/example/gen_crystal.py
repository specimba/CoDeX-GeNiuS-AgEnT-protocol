import bpy, random, math
random.seed(7)
# clean slate
bpy.ops.wm.read_factory_settings(use_empty=True)
# crystal: low-poly icosphere, radially stretched, flat-shaded
bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=1, radius=1.0, location=(0,0,0))
obj = bpy.context.active_object
me = obj.data
# make it an elongated shard
for v in me.vertices:
    x,y,z = v.co
    r = math.sqrt(x*x+y*y)
    a = math.atan2(y,x)
    r2 = r*(0.75+0.25*math.sin(3*a))          # 3-fold cross-section
    z2 = z*1.6 + 0.2*math.sin(2*a+z*2)
    v.co = (r2*math.cos(a), r2*math.sin(a), z2)
bpy.ops.object.mode_set(mode='EDIT')
bpy.ops.mesh.select_all(action='SELECT')
bpy.ops.mesh.remove_doubles(threshold=0.001)
bpy.ops.object.mode_set(mode='OBJECT')
bpy.ops.object.shade_flat()
# simple gold-ish material
mat = bpy.data.materials.new("ember_gold")
mat.use_nodes = True
bsdf = mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.95, 0.6, 0.08, 1.0)
bsdf.inputs["Metallic"].default_value = 0.85
bsdf.inputs["Roughness"].default_value = 0.35
obj.data.materials.append(mat)
# export glTF binary
bpy.ops.export_scene.gltf(filepath="/tmp/blend_poc/crystal.glb", export_format='GLB')
# CPU render proof (no GPU anywhere)
bpy.context.scene.render.engine = 'CYCLES'
bpy.context.scene.cycles.device = 'CPU'
bpy.context.scene.render.resolution_x = 256
bpy.context.scene.render.resolution_y = 256
bpy.ops.object.camera_add(location=(3.2,-3.4,2.2))
cam = bpy.context.active_object
bpy.context.scene.camera = cam
cam.rotation_euler = (math.radians(62), 0, math.radians(43))
bpy.ops.object.light_add(type='SUN', location=(4,4,6))
bpy.context.scene.render.filepath = "/tmp/blend_poc/crystal_render.png"
bpy.ops.render.render(write_still=True)
print("DONE", [f for f in __import__('os').listdir('/tmp/blend_poc')])
