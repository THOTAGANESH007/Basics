import os
import json

# extensions you want to allow
ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png'}

def file_traversal(path):
    result = {'name':path, 'type':'folder', 'children':[]}
    if not os.path.exists(path):
        return result
    
    for entry in os.listdir(path):
        combined_path = os.path.join(path,entry)
        
        if os.path.isdir(combined_path):
            result['children'].append(file_traversal(combined_path))
        #else:
        #    result['children'].append({'name':entry, 'type':'file'})
        else:
            # get file extension
            _, ext = os.path.splitext(entry)

            # filter by extension
            if ext.lower() in ALLOWED_EXTENSIONS:
                result['children'].append({
                    'name': entry,
                    'type': 'file'
                })
    return result

folder_path = "/home/ganesh.thota/Pictures"

folder_json = file_traversal(folder_path)
# print(folder_json)

folder_json_str = json.dumps(folder_json,indent=2)

print(folder_json_str)
