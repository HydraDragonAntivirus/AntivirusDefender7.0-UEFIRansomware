def remove_inline_comments(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    new_lines = []
    for line in lines:
        quote_count = line.count('"') + line.count("'")
        if '#' in line and quote_count % 2 == 0:
            # Split the line into two parts: before and after the '#'
            parts = line.split('#', 1)
            # Only keep the part before the '#'
            line = parts[0].rstrip() + '\n'
        new_lines.append(line)

    with open(filename, 'w') as f:
        f.writelines(new_lines)

remove_inline_comments('hatasiz2.py')