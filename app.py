#! /usr/bin/env python
import json
import tempfile

from werkzeug.wsgi import wrap_file
from werkzeug.wrappers import Request, Response
from executor import execute


@Request.application
def application(request):
    if request.method != 'POST':
        return

    request_is_json = request.content_type.endswith('json')

    with tempfile.NamedTemporaryFile(suffix='.html') as source_file:

        if request_is_json:
            # If a JSON payload is there, all data is in the payload
            payload = json.loads(request.data)
            source_file.write(payload['contents'].decode('base64'))
            options = payload.get('options', {})
        elif request.files:
            # First check if any files were uploaded
            source_file.write(request.files['file'].read())
            # Load any options that may have been provided in options
            options = json.loads(request.form.get('options', '{}'))

        source_file.flush()

        # Evaluate argument to run with subprocess
        args = ['wkhtmltopdf --encoding UTF-8']

        # Add Global Options
        if options:
            for option, value in options.items():
                args.append('--%s' % option)
                if value:
                    args.append('"%s"' % value)

        # Add source file name and output file name
        file_name = source_file.name
        args += [file_name, file_name + ".pdf"]

        # Execute the command using executor
        execute(' '.join(args))

        return Response(
            wrap_file(request.environ, open(file_name + '.pdf')),
            mimetype='application/pdf',
        )


if __name__ == '__main__':
    from werkzeug.serving import run_simple

    run_simple(
        '127.0.0.1', 5000, application, use_debugger=True, use_reloader=True
    )
