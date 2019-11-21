# jupyter config options go here
# usually goes into ~/.jupyter/jupyter_botebook_config.py



#-------
# custom code
#-------
import sys
import json
import os
import re

#sys.setdefaultencoding('utf8')


def get_notebook_data(path_to_file):
    with open(path_to_file, 'r', encoding='UTF-8') as notebook:
        notebook_data = json.load(notebook)
    return notebook_data


def construct_output_py_file_path(input_file_path, skip_if_exists=True):
    input_headless, ext = os.path.splitext(input_file_path)
    assert ext=='.ipynb'
    output_by_path = input_headless + '.py'
    if os.path.exists(output_by_path) and skip_if_exists:
        return
    return output_by_path


def write_notebook_data_to_py(notebook_data, out_file_path):
    with open(out_file_path, 'w', encoding='UTF-8') as output:
        output.write('# -*- coding: utf-8 -*-\n')
        output.write('# <nbformat>' + str(notebook_data['nbformat']) + '</nbformat>\n')
        try:
            cells = notebook_data['cells']
        except KeyError:
            print("Nbformat is " + str(notebook_data['nbformat']) + ", try the old converter script.")
            return

        for cell in cells:
            if cell['cell_type'] in ['code', 'markdown']:
                output.write('\n')
                output.write('# <' + cell['cell_type'] + 'cell' + '>\n')
                output.write('\n')
                for item in cell['source']:
                    if cell['cell_type']=='code':
                        output.write(re.sub(r"^(%.*)$", r"#\1", item, re.MULTILINE))
                    else:
                        output.write('# ')
                        output.write(item)
                output.write('\n')


def create_git_commit(os_path):
    from subprocess import check_call
    from shlex import split

    workdir, filename = os.path.split(os_path)

    check_call(split('git add {}'.format(filename)), cwd=workdir)
    check_call(split('git commit -m "[NOTEBOOK SNAPSHOT]:" {}'.format(filename)), cwd=workdir)
    # check_call(split('git push'), cwd=workdir)


def post_save(model, os_path, contents_manager):
    """post-save hook for converting notebooks to .py scripts"""
    if model['type'] != 'notebook':
        return # only do this for notebooks
    if 'Untitled' in os_path:
        return # do not save untitled notebooks

    output_file_path = construct_output_py_file_path(os_path, skip_if_exists=False)
    notebook_data = get_notebook_data(os_path)
    write_notebook_data_to_py(notebook_data, output_file_path)
    print(output_file_path, "was successfully saved")

    #create_git_commit(os_path)
    #print(output_file_path, "was successfully committed")

c = get_config()
c.FileContentsManager.post_save_hook = post_save
