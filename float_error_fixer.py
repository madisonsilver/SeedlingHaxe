import re
import subprocess
import os


def get_errors():
    return (subprocess.run(["lime", "build", "html5"], stderr=subprocess.PIPE).stderr).decode("utf-8")


def extract_name_and_files(errors):
    formatted_errors = {}
    for (file, line_raw, data) in errors:
        line = int(line_raw)
        if file not in formatted_errors:
            formatted_errors[file] = {}
        if line not in formatted_errors[file]:
            formatted_errors[file][line] = []
        formatted_errors[file][line].append(data)
    return formatted_errors


def fix_float_functions(raw_text):
    matches = list(re.finditer(
        r'^([^:]+):(\d+): characters (\d+)-(\d+) : Float should be Int\n.*For (?:optional )?function argument.*$', raw_text,  re.MULTILINE))
    errors = [x.group(1, 2, 3, 4) for x in matches]

    formatted_errors = {}
    for (file, line_raw, char_start, char_end) in errors:
        line = int(line_raw)
        if file not in formatted_errors:
            formatted_errors[file] = {}
        if line not in formatted_errors[file]:
            formatted_errors[file][line] = []
        formatted_errors[file][line].append((int(char_start), int(char_end)))

    for k in formatted_errors.keys():
        for l in formatted_errors[k].keys():
            def custom_key(data): return data[0]
            sorted_errors = sorted(formatted_errors[k][l], key=custom_key, reverse=True)
            for i in range(len(sorted_errors)-1):
                for j in range(i+1, len(sorted_errors)):
                    first = sorted_errors[i]
                    second = sorted_errors[j]
                    assert (first[0] > second[1])
            formatted_errors[k][l] = sorted_errors

    for file in formatted_errors.keys():
        with open(file) as f:
            file_contents = f.read()
        split_contents = file_contents.split("\n")
        for line in formatted_errors[file]:
            for char_start, char_end in formatted_errors[file][line]:
                old_line = split_contents[line-1]
                new_line = old_line[:char_start-1] + \
                    "Std.int("+old_line[char_start-1:char_end-1]+")"+old_line[char_end-1:]
                split_contents[line-1] = new_line
        with open(file, "w") as f:
            f.write("\n".join(split_contents))


def fix_int_assignments(raw_text):
    matches = list(re.finditer(
        r'^([^:]+):(\d+): characters (\d+)-(\d+) : Float should be Int$', raw_text,  re.MULTILINE))
    errors = [(x.group(1), x.group(2), ()) for x in matches]
    formatted_errors = extract_name_and_files(errors)

    for file in formatted_errors.keys():
        with open(file) as f:
            file_contents = f.read()
        split_contents = file_contents.split("\n")
        for line in formatted_errors[file]:
            old_line = split_contents[line-1]
            m = re.fullmatch(r'^([^=\n]*)=([^=\n]*);([^;]*)$', old_line)
            if m:
                new_line = f"{m.group(1)}=Std.int({m.group(2)});{m.group(3)}"
                split_contents[line-1] = new_line
        with open(file, "w") as f:
            f.write("\n".join(split_contents))


# BROKEN
def fix_bool_casts(raw_text):
    matches = list(re.finditer(
        r'^([^:]+):(\d+): characters (\d+)-(\d+) : (.*) should be Bool$', raw_text,  re.MULTILINE))
    errors = [x.group(1, 2, 3, 4, 5) for x in matches]

    formatted_errors = {}
    for (file, line_raw, char_start, char_end, data_type) in errors:
        line = int(line_raw)
        if file not in formatted_errors:
            formatted_errors[file] = {}
        if line not in formatted_errors[file]:
            formatted_errors[file][line] = []
        formatted_errors[file][line].append((int(char_start), int(char_end), data_type))

    for k in formatted_errors.keys():
        for l in formatted_errors[k].keys():
            def custom_key(data): return data[0]
            sorted_errors = sorted(formatted_errors[k][l], key=custom_key, reverse=True)
            i = 0
            while i < len(sorted_errors)-1:
                j = i+1
                while j < len(sorted_errors):
                    first = sorted_errors[i]
                    second = sorted_errors[j]
                    if not (first[0] > second[1]):
                        if (second[1] > first[1]):
                            del sorted_errors[i]
                            i = 0
                            j = 0
                        else:
                            print(k, l)
                            exit(-1)
                    j += 1
                i += 1
            formatted_errors[k][l] = sorted_errors

    for file in formatted_errors.keys():
        with open(file) as f:
            file_contents = f.read()
        split_contents = file_contents.split("\n")
        for line in formatted_errors[file]:
            for char_start, char_end, data_type in formatted_errors[file][line]:
                if data_type not in ["Int", "String", "Float"]:
                    old_line = split_contents[line-1]
                    new_line = old_line[:char_start-1] + \
                        "(("+old_line[char_start-1:char_end-1]+")!=null)"+old_line[char_end-1:]
                    split_contents[line-1] = new_line
                    print(old_line)
                    print(new_line)
        # with open(file, "w") as f:
        #   .write("\n".join(split_contents))

# BROKEN/UNFINISHED


def fix_image_imports(filename):
    with open(filename) as f:
        file_contents = f.read()
    lines = file_contents.split("\n")
    filtered_lines = []

    load_assets = []
    initialize_assets = []

    found_new = False
    has_imported = False

    i = 0
    while i < len(lines):
        if "package" not in lines[i] and not has_imported:
            filtered_lines.append("import openfl.utils.Assets;import openfl.display.BitmapData;")
            has_imported = True

        path_match = re.fullmatch(r'^\s*@:meta\(Embed\(source = "(?:..\/)*assets\/([^.]*)\.png"\)\)\s*$', lines[i])
        if path_match:
            path_start = path_match.group(1)
            full_path = f"assets/{path_start}.png"
            variable_match = re.fullmatch(r'\s*([^\s].*) ([^\s]*):Class<Dynamic>;\s*$', lines[i+1])
            if variable_match:
                var_prefixes, var_name = variable_match.group(1, 2)
                filtered_lines.append(f"{var_prefixes} {var_name}:BitmapData;")

                load_assets.append(f'{var_name} = Assets.getBitmapData("{full_path}");')

                i += 1
            else:
                raise Exception(f"Embed without matching variable? {i}")
        else:
            assignment_match = re.fullmatch(r'^\s*(\S.*) var (\S*):Spritemap = new Spritemap\(([^)]*)\);\s*$', lines[i])
            alt_assignment_match = re.fullmatch(
                r'^\s*(\S.*) var (\S*):Image = new Image\(([^)]*)\);\s*$', lines[i])
            if assignment_match:
                assert not found_new
                var_visibility, var_name, initializer_data = assignment_match.group(1, 2, 3)

                initialize_assets.append(f'{var_name} = new Spritemap({initializer_data});')
                filtered_lines.append(f'{var_visibility} var {var_name} : Spritemap;')
            elif alt_assignment_match:
                assert not found_new
                var_visibility, var_name, initializer_data = alt_assignment_match.group(1, 2, 3)

                initialize_assets.append(f'{var_name} = new Image({initializer_data});')
                filtered_lines.append(f'{var_visibility} var {var_name} : Image;')
            elif "function new(" in lines[i] and "{" in lines[i]:
                assert not found_new
                found_new = True

                function_calls = ""

                if len(load_assets) > 0:
                    filtered_lines.append("private function load_image_assets():Void {")
                    for l in load_assets:
                        filtered_lines.append(l)
                    filtered_lines.append("}")
                    function_calls+="load_image_assets();"
                if len(initialize_assets) > 0:
                    filtered_lines.append("private function initialize_image_assets():Void {")
                    for l in initialize_assets:
                        filtered_lines.append(l)
                    filtered_lines.append("}")
                    function_calls += "initialize_image_assets();"

                if lines[i][-1] == "}":
                    filtered_lines.append(lines[i][:-1]+function_calls+"}")
                else:
                    filtered_lines.append(lines[i])
                    filtered_lines.append(function_calls)
            else:
                filtered_lines.append(lines[i])
        i += 1
    assert found_new

    file_output = "\n".join(filtered_lines)
    with open(filename, "w") as f:
        f.write(file_output)


def fix_audio_imports(filename):
    with open(filename) as f:
        file_contents = f.read()
    lines = file_contents.split("\n")
    filtered_lines = []

    load_assets = []
    initialize_assets = []

    found_new = False
    has_imported = False

    i = 0
    while i < len(lines):
        path_match = re.fullmatch(r'^\s*@:meta\(Embed\(source = "(?:..\/)*assets\/([^.]*)\.mp3"\)\)\s*$', lines[i])
        if path_match:
            path_start = path_match.group(1)
            full_path = f"assets/{path_start}.mp3"
            variable_match = re.fullmatch(r'\s*([^\s].*) ([^\s]*):Class<Dynamic>;\s*$', lines[i+1])
            if variable_match:
                var_prefixes, var_name = variable_match.group(1, 2)
                filtered_lines.append(f"{var_prefixes} {var_name}:Sound;")

                load_assets.append(f'{var_name} = Assets.getSound("{full_path}");')

                i += 1
            else:
                raise Exception(f"Embed without matching variable? {lines[i]}")
        else:
            assignment_match = re.fullmatch(r'^\s*(\S.*) var (\S*):Sfx = new Sfx\(([^)]*)\);\s*$', lines[i])
            if assignment_match:
                assert not found_new
                var_visibility, var_name, initializer_data = assignment_match.group(1, 2, 3)

                initialize_assets.append(f'{var_name} = new Sfx({initializer_data});')
                filtered_lines.append(f'{var_visibility} var {var_name} : Sfx;')
            elif "function new(" in lines[i] and "{" in lines[i]:
                assert not found_new
                found_new = True

                function_calls = ""

                if len(load_assets) > 0:
                    filtered_lines.append("private function load_audio_assets():Void {")
                    for l in load_assets:
                        filtered_lines.append(l)
                    filtered_lines.append("}")
                    function_calls+="load_audio_assets();"
                if len(initialize_assets) > 0:
                    filtered_lines.append("private function initialize_audio_assets():Void {")
                    for l in initialize_assets:
                        filtered_lines.append(l)
                    filtered_lines.append("}")
                    function_calls += "initialize_audio_assets();"

                if lines[i][-1] == "}":
                    filtered_lines.append(lines[i][:-1]+function_calls+"}")
                else:
                    filtered_lines.append(lines[i])
                    filtered_lines.append(function_calls)
            else:
                filtered_lines.append(lines[i])
        i += 1
    assert found_new

    file_output = "\n".join(filtered_lines)
    with open(filename, "w") as f:
        f.write(file_output)

def fix_level_imports():
    filename = "hx/Game.hx"
    with open(filename) as f:
        file_contents = f.read()
    lines = file_contents.split("\n")
    filtered_lines = []

    load_assets = []
    initialize_assets = []

    found_new = False
    has_imported = False

    i = 0
    while i < len(lines):
        path_match = re.fullmatch(r'^\s*\/\*\d*\s*\*\/ @:meta\(Embed\(source = "(?:..\/)*assets\/([^.]*)\.oel", mimeType = "application\/octet-stream"\)\)\s*$', lines[i])
        if path_match:
            path_start = path_match.group(1)
            full_path = f"assets/{path_start}.oel"
            variable_match = re.fullmatch(r'\s*([^\s].*) ([^\s]*):Class<Dynamic>;\s*$', lines[i+1])
            if variable_match:
                var_prefixes, var_name = variable_match.group(1, 2)
                filtered_lines.append(f"{var_prefixes} {var_name}:String;")

                load_assets.append(f'{var_name} = Assets.getText("{full_path}");')

                i += 1
            else:
                raise Exception(f"Embed without matching variable? {lines[i]}")
        else:
            if "function new(" in lines[i] and "{" in lines[i]:
                assert not found_new
                found_new = True

                function_calls = ""

                if len(load_assets) > 0:
                    filtered_lines.append("private function load_level_assets():Void {")
                    for l in load_assets:
                        filtered_lines.append(l)
                    filtered_lines.append("}")
                    function_calls+="load_level_assets();"

                if lines[i][-1] == "}":
                    filtered_lines.append(lines[i][:-1]+function_calls+"}")
                else:
                    filtered_lines.append(lines[i])
                    filtered_lines.append(function_calls)
            else:
                filtered_lines.append(lines[i])
        i += 1
    assert found_new

    file_output = "\n".join(filtered_lines)
    with open(filename, "w") as f:
        f.write(file_output)



def fix_variable_initialization(raw_text):
    matches = re.finditer(
        r'^([^:]*):(\d*): characters \d*-\d* : Cannot access this or other member field in variable initialization$', raw_text,  re.MULTILINE)
    errors = [(x.group(1), x.group(2), ()) for x in matches]

    formatted_errors = extract_name_and_files(errors)
    for file in formatted_errors:
        with open(file) as f:
            file_contents = f.read()
        file_lines = file_contents.split("\n")
        extracted_initializers = []
        for line in formatted_errors[file]:
            line_match = re.fullmatch(r'^(.*) var ([^:(]*)([^=]*)=([^;]*);([^;]*)$', file_lines[line-1])
            (visibility, name, type, initializer, comments) = line_match.group(1, 2, 3, 4, 5)
            new_line = f"{visibility} var {name}{type};{comments}"
            initializer = f"{name} = {initializer};"

            file_lines[line-1] = new_line
            extracted_initializers.append(initializer)

        new_pos = -1
        for i in range(len(file_lines)):
            if "function new(" in file_lines[i] and "{" in file_lines[i]:
                new_pos = i
                break
        assert new_pos >= 0
        new_file_lines = file_lines[:new_pos+1] + extracted_initializers + file_lines[new_pos+1:]
        new_file_content = "\n".join(new_file_lines)
        with open(file, "w") as f:
            file_contents = f.write(new_file_content)

# fix_variable_initialization(get_errors())

fix_level_imports()

"""
for subdir, dirs, files in os.walk("hx"):
    for file in files:
        path = os.path.join(subdir, file)
        try:
            fix_audio_imports(path)
        except AssertionError:
            print(f"Error: {path}")
"""

# errors = get_errors()
# fix_int_assignments(errors)
