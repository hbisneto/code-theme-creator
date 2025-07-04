from flask import Flask, request, send_file
from flask_cors import CORS
import json
import os
import zipfile
import io
from filesystem import directory as dir 

app = Flask(__name__)
CORS(app)

@app.route('/generate-theme', methods=['POST'])
def generate_theme():

    
    license_file = """MIT License

Copyright (c) 2022 Heitor Bardemaker A. Bisneto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."""
    
    # Verifica se há dados JSON no request
    if not request.is_json:
        return "Dados JSON ausentes", 400
    
    theme_data = request.get_json()
    print(theme_data)
    print(theme_data['name'])
    # print(theme_data['description'])
    
    # Validação básica
    if not theme_data or "name" not in theme_data or "colors" not in theme_data:
        return "Nome e cores são obrigatórios", 400

    theme_json = {
        "$schema": "vscode://schemas/color-theme",
        "name": theme_data["name"],
        "type": "dark",
        "colors": theme_data["colors"],
        "tokenColors": []
    }

    # Cria as pastas padrao
    theme_dir = f"theme_{theme_data['name']}"
    assets_folder = dir.join(theme_dir, "assets")
    themes_folder = dir.join(theme_dir, "themes")
    dark_theme_folder = dir.join(themes_folder, "Dark")
    light_theme_folder = dir.join(themes_folder, "Light")
    os.makedirs(theme_dir, exist_ok=True)
    dir.create(assets_folder)
    dir.create(themes_folder)
    dir.create(dark_theme_folder)
    dir.create(light_theme_folder)
    # os.makedirs(f'{theme_dir}/{assets_folder}', exist_ok=True)
    # os.makedirs(f'{theme_dir}/{themes_folder}', exist_ok=True)
    # os.makedirs(f'{theme_dir}/{themes_folder}/{dark_theme_folder}', exist_ok=True)
    # os.makedirs(f'{theme_dir}/{themes_folder}/{light_theme_folder}', exist_ok=True)

    # package_json = {
    #     "name": f"theme-{theme_data['name'].lower().replace(' ', '-')}",
    #     "displayName": theme_data["name"],
    #     "description": f"A custom VS Code theme: {theme_data['name']}",
    #     "version": "1.0.0",
    #     "engines": {"vscode": "^1.60.0"},
    #     "categories": ["Themes"],
    #     "contributes": {
    #         "themes": [{
    #             "label": theme_data["name"],
    #             "uiTheme": "vs-dark",
    #             "path": f"./{theme_data['name']}.json"
    #         }]
    #     }
    # }
    package_json = {
        # "name":"theme-excel",
        "name":f"theme-{theme_data['name'].lower().replace(' ', '-')}",
        "displayName":"%displayName%",
        "description":"%description%",
        "categories":["Themes"],
        "version":"1.0.0", # Create a version identifier in theme-form.html (major.minor.build.release)
        "publisher":f"{theme_data['publisher']}",
        "icon": "assets/icon.png",
        "license":"MIT",
        "engines": 
        {
            "vscode": "^1.60.0"
        },
        "contributes":
        {
            "themes":
            [
                {
                    "id":f"{theme_data['name']} (Dark)",
                    "label":f"%{theme_data['name']}Dark%",
                    "uiTheme":"vs-dark",
                    "path":f"./themes/Dark/{theme_data['name']}-dark.json"
                },
                {
                    "id":f"{theme_data['name']} (Light)",
                    "label":f"%{theme_data['name']}Light%",
                    "uiTheme":"vs",
                    "path":f"./themes/Light/{theme_data['name']}-light.json"
                }
            ]
        },
        "repository":
        {
            "type":"git",
            "url":"https://github.com/hbisneto/code-theme-creator.git"
        }
    }
    package_nls_json = {
        "displayName":f"{theme_data['name']} Theme",
        "description":f"{theme_data['description']}",

        f"{theme_data['name']}Dark":f"{theme_data['name']} Theme (Dark)",
        f"{theme_data['name']}Light":f"{theme_data['name']} Theme (Light)"
    }

    with open(f"{theme_dir}/package.json", "w") as f:
        json.dump(package_json, f, indent=2)
    
    with open(f"{theme_dir}/package.nls.json", "w") as f:
        json.dump(package_nls_json, f, indent=2)

    # with open(f"{theme_dir}/{theme_data['name']}.json", "w") as f:
    #     json.dump(theme_json, f, indent=2)

    with open(f"{theme_dir}/LICENSE", "w") as f:
        f.write(license_file)
    
    with open(f"{assets_folder}/icon.thm", "w") as f:
        f.write(">> A default icon for created themes will be created soon. Stay tuned!")

    with open(f"{dark_theme_folder}/{theme_data['name']}-dark.json", "w") as f:
        json.dump(theme_json, f, indent=2)

    with open(f"{light_theme_folder}/{theme_data['name']}-light.json", "w") as f:
        f.write(">> Light theme will be implemented soon. Stay tuned!")

    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, "a", zipfile.ZIP_DEFLATED, False) as zip_file:
        # for root, _, files in os.walk(theme_dir):
        for root, dirs, files in os.walk(theme_dir):
            for file in files:
                file_path = os.path.join(root, file)
                # Mantém os arquivos na raiz conforme a estrutura local
                arcname = os.path.relpath(file_path, theme_dir)
                zip_file.write(file_path, arcname)
                # file_path = os.path.join(root, file)
                # zip_file.write(file_path, os.path.relpath(file_path, theme_dir))

    for root, _, files in os.walk(theme_dir, topdown=False):
        for file in files:
            os.remove(os.path.join(root, file))
        os.rmdir(root)

    zip_buffer.seek(0)
    return send_file(
        zip_buffer,
        mimetype="application/zip",
        as_attachment=True,
        download_name=f"{theme_data['name']}.zip"
    )

if __name__ == "__main__":
    app.run(debug=True)