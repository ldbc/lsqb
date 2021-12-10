import xgt
import os

vertex_labels = ["City", "Comment", "Company", "Continent", "Country", "Forum", "Person", "Post", "TagClass", "Tag", "University"]

edge_types = [
    {"src": "City",       "label": "isPartOf",     "trg": "Country",    "bidirectional": False},
    {"src": "Comment",    "label": "hasCreator",   "trg": "Person",     "bidirectional": False},
    {"src": "Comment",    "label": "hasTag",       "trg": "Tag",        "bidirectional": False},
    {"src": "Comment",    "label": "isLocatedIn",  "trg": "Country",    "bidirectional": False},
    {"src": "Comment",    "label": "replyOf",      "trg": "Comment",    "bidirectional": False},
    {"src": "Comment",    "label": "replyOf",      "trg": "Post",       "bidirectional": False},
    {"src": "Company",    "label": "isLocatedIn",  "trg": "Country",    "bidirectional": False},
    {"src": "Country",    "label": "isPartOf",     "trg": "Continent",  "bidirectional": False},
    {"src": "Forum",      "label": "containerOf",  "trg": "Post",       "bidirectional": False},
    {"src": "Forum",      "label": "hasMember",    "trg": "Person",     "bidirectional": False},
    {"src": "Forum",      "label": "hasModerator", "trg": "Person",     "bidirectional": False},
    {"src": "Forum",      "label": "hasTag",       "trg": "Tag",        "bidirectional": False},
    {"src": "Person",     "label": "hasInterest",  "trg": "Tag",        "bidirectional": False},
    {"src": "Person",     "label": "isLocatedIn",  "trg": "City",       "bidirectional": False},
    {"src": "Person",     "label": "knows",        "trg": "Person",     "bidirectional": True},
    {"src": "Person",     "label": "likes",        "trg": "Comment",    "bidirectional": False},
    {"src": "Person",     "label": "likes",        "trg": "Post",       "bidirectional": False},
    {"src": "Person",     "label": "studyAt",      "trg": "University", "bidirectional": False},
    {"src": "Person",     "label": "workAt",       "trg": "Company",    "bidirectional": False},
    {"src": "Post",       "label": "hasCreator",   "trg": "Person",     "bidirectional": False},
    {"src": "Post",       "label": "hasTag",       "trg": "Tag",        "bidirectional": False},
    {"src": "Post",       "label": "isLocatedIn",  "trg": "Country",    "bidirectional": False},
    {"src": "TagClass",   "label": "isSubclassOf", "trg": "TagClass",   "bidirectional": False},
    {"src": "Tag",        "label": "hasType",      "trg": "TagClass",   "bidirectional": False},
    {"src": "University", "label": "isLocatedIn",  "trg": "City",       "bidirectional": False},
]

path = f"xgtd://"

conn = xgt.Connection()
admin_conn = xgt.Connection(userid='xgtd')
admin_conn.set_config({'metrics.cache' : False})

# Drop all objects
[conn.drop_frame(f"lsqb__{t['src']}_{t['label']}_{t['trg']}") for t in edge_types]
[conn.drop_frame(f'lsqb__{l}') for l in vertex_labels]

# Define and create the graph schema in the "lsqb" namespace
vertex_frames = {}
edge_frames = {}

print("loading data...")
print("loading vertices:")
for vertex_label in vertex_labels:
    vertex_frames[vertex_label] = conn.create_vertex_frame(name=f'lsqb__{vertex_label}', schema=[['id', xgt.INT]], key='id')
    
    print(f"- loading {path}{vertex_label}.csv")
    vertex_frames[vertex_label].load(
        paths=f'{path}{vertex_label}.csv',
        headerMode=xgt.HeaderMode.IGNORE,
        delimiter='|'
    )

print("loading edges:")
for t in edge_types:
    edge_label_full_name = f"{t['src']}_{t['label']}_{t['trg']}"
    edge_frames[edge_label_full_name] = conn.create_edge_frame(
        name=f"lsqb__{edge_label_full_name}",
        schema=[['src_id', xgt.INT], ['trg_id', xgt.INT]],
        source=vertex_frames[t['src']],
        target=vertex_frames[t['trg']],
        source_key='src_id',
        target_key='trg_id'
    )

    print(f"- loading {path}{edge_label_full_name}.csv")
    edge_frames[edge_label_full_name].load(
        paths=f"{path}{edge_label_full_name}.csv",
        headerMode=xgt.HeaderMode.IGNORE,
        delimiter='|')

    if (t['bidirectional']):
        edge_frames[edge_label_full_name].load(
            paths=f"{path}{edge_label_full_name}-reverse.csv",
            headerMode=xgt.HeaderMode.IGNORE,
            delimiter='|')

print("data loaded")
print("computing metrics...")
admin_conn.set_config({'metrics.cache' : True})
conn.wait_for_metrics()

print("metrics computed")
