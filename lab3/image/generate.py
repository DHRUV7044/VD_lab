#!/usr/bin/env python3

import json
import os
import sys

from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader


PAGE_WIDTH, PAGE_HEIGHT = A4
MM = 72 / 25.4

DEFAULT_MARGIN_MM = 5
DEFAULT_GAP_MM = 3
DEFAULT_SECTION_FONT_SIZE = 14
DEFAULT_CAPTION_FONT_SIZE = 12

CONFIG_FILE = "config.json"
DEFAULT_OUTPUT_FILE = "lab_record.pdf"


def resolve_output_filename(raw):
    """Sanitize and normalise the user-supplied output filename."""

    import re

    if not raw or not str(raw).strip():
        return DEFAULT_OUTPUT_FILE

    name = str(raw).strip()
    name = re.sub(r'[\\/:*?"<>|]', '', name)
    name = re.sub(r'\s+', ' ', name).strip()

    if not name:
        return DEFAULT_OUTPUT_FILE

    if name.lower().endswith('.pdf'):
        return name

    return name + '.pdf'


def load_config():

    if not os.path.exists(CONFIG_FILE):
        print(f"ERROR: {CONFIG_FILE} not found.")
        sys.exit(1)

    try:
        with open(CONFIG_FILE, "r", encoding="utf-8") as file:
            return json.load(file)

    except json.JSONDecodeError as error:
        print("ERROR: Invalid config.json")
        print(error)
        sys.exit(1)


def get_image_size(path):

    try:
        with Image.open(path) as image:
            return image.size

    except Exception as error:
        print(f"ERROR: Cannot open image: {path}")
        print(error)
        sys.exit(1)


def get_rotated_dimensions(width, height, rotation):

    rotation = rotation % 360

    if rotation in (90, 270):
        return height, width

    return width, height


def calculate_scale(
    image_width,
    image_height,
    available_width,
    available_height
):

    scale_x = available_width / image_width
    scale_y = available_height / image_height

    return min(scale_x, scale_y)


def draw_image(
    pdf,
    image_path,
    center_x,
    center_y,
    scale,
    rotation
):

    rotation = rotation % 360

    image = ImageReader(image_path)

    original_width, original_height = get_image_size(
        image_path
    )

    final_width = original_width * scale
    final_height = original_height * scale

    pdf.saveState()

    pdf.translate(center_x, center_y)
    pdf.rotate(rotation)

    pdf.drawImage(
        image,
        -final_width / 2,
        -final_height / 2,
        width=final_width,
        height=final_height,
        preserveAspectRatio=True,
        mask="auto"
    )

    pdf.restoreState()


def draw_section_heading(
    pdf,
    section_number,
    section_name,
    margin,
    font_size
):

    heading = f"{section_number}. {section_name}"

    pdf.setFont(
        "Helvetica-Bold",
        font_size
    )

    heading_y = PAGE_HEIGHT - margin

    pdf.drawString(
        margin,
        heading_y,
        heading
    )

    underline_y = heading_y - 5

    pdf.setLineWidth(0.5)

    pdf.line(
        margin,
        underline_y,
        PAGE_WIDTH - margin,
        underline_y
    )

    return font_size * 1.25 + 5


def draw_caption(
    pdf,
    figure_number,
    title,
    y,
    font_size
):

    title = str(title).replace(
        "\\n",
        "\n"
    )

    text = f"Figure {figure_number}: {title}"

    pdf.setFont(
        "Helvetica-Bold",
        font_size
    )

    lines = text.split("\n")

    line_height = font_size * 1.25

    for index, line in enumerate(lines):

        pdf.drawCentredString(
            PAGE_WIDTH / 2,
            y - (index * line_height),
            line
        )

    return len(lines) * line_height


def draw_image_page(
    pdf,
    image_item,
    figure_number,
    section,
    settings,
    first_page
):

    margin = settings["margin_mm"] * MM
    gap = settings["gap_mm"] * MM

    section_font_size = settings[
        "section_font_size"
    ]

    caption_font_size = settings[
        "caption_font_size"
    ]

    image_path = image_item.get(
        "image",
        ""
    )

    title = image_item.get(
        "title",
        ""
    )

    rotation = image_item.get(
        "rotation",
        0
    )

    if not image_path:

        print(
            f"WARNING: No image specified "
            f"for ID {image_item.get('id')}"
        )

        return

    if not os.path.exists(image_path):

        print(
            f"WARNING: Image not found: "
            f"{image_path}"
        )

        return

    section_height = 0

    if first_page:

        section_height = draw_section_heading(
            pdf,
            section.get("number", 1),
            section.get("name", "IMAGE"),
            margin,
            section_font_size
        )

    caption_gap = 8 * MM

    caption_y = (
        PAGE_HEIGHT
        - margin
        - section_height
        - caption_gap
    )

    caption_height = draw_caption(
        pdf,
        figure_number,
        title,
        caption_y,
        caption_font_size
    )

    image_area_x = margin
    image_area_y = margin

    image_area_width = (
        PAGE_WIDTH - 2 * margin
    )

    image_area_height = (
        PAGE_HEIGHT
        - 2 * margin
        - section_height
        - caption_gap
        - caption_height
        - gap
    )

    if image_area_height <= 0:

        print(
            f"WARNING: Not enough space "
            f"for Figure {figure_number}"
        )

        return

    original_width, original_height = (
        get_image_size(image_path)
    )

    rotated_width, rotated_height = (
        get_rotated_dimensions(
            original_width,
            original_height,
            rotation
        )
    )

    scale = calculate_scale(
        rotated_width,
        rotated_height,
        image_area_width,
        image_area_height
    )

    center_x = (
        image_area_x
        + image_area_width / 2
    )

    center_y = (
        image_area_y
        + image_area_height / 2
    )

    draw_image(
        pdf,
        image_path,
        center_x,
        center_y,
        scale,
        rotation
    )


def validate_ids(pages):

    ids = []

    for item in pages:

        if "id" not in item:

            print(
                "ERROR: Every image must have an 'id'."
            )

            sys.exit(1)

        try:

            item_id = int(item["id"])

        except (ValueError, TypeError):

            print(
                f"ERROR: Invalid image ID: "
                f"{item['id']}"
            )

            sys.exit(1)

        if item_id in ids:

            print(
                f"ERROR: Duplicate image ID: "
                f"{item_id}"
            )

            sys.exit(1)

        ids.append(item_id)

    return ids


def sort_pages_by_id(pages):

    validate_ids(pages)

    return sorted(
        pages,
        key=lambda item: int(item["id"])
    )


def generate_pdf():

    config = load_config()

    settings = {

        "margin_mm": config.get(
            "margin_mm",
            DEFAULT_MARGIN_MM
        ),

        "gap_mm": config.get(
            "image_gap_mm",
            DEFAULT_GAP_MM
        ),

        "section_font_size": config.get(
            "section_font_size",
            DEFAULT_SECTION_FONT_SIZE
        ),

        "caption_font_size": config.get(
            "caption_font_size",
            DEFAULT_CAPTION_FONT_SIZE
        )
    }

    section = config.get(
        "section",
        {}
    )

    pages = config.get(
        "pages",
        []
    )

    if not pages:

        print(
            "ERROR: No images found."
        )

        sys.exit(1)

    pages = sort_pages_by_id(pages)

    output_file = resolve_output_filename(
        config.get("output_filename", "")
    )

    pdf = canvas.Canvas(
        output_file,
        pagesize=A4
    )

    pdf.setTitle(
        "VLSI Engineering Lab Record"
    )

    for figure_number, image_item in enumerate(
        pages,
        start=1
    ):

        first_page = (
            figure_number == 1
        )

        draw_image_page(
            pdf,
            image_item,
            figure_number,
            section,
            settings,
            first_page
        )

        pdf.showPage()

    pdf.save()

    print()
    print("========================================")
    print(" PDF GENERATED SUCCESSFULLY")
    print("========================================")
    print()
    print(
        f"Section : "
        f"{section.get('number', 1)}. "
        f"{section.get('name', 'IMAGE')}"
    )
    print(
        f"Figures : {len(pages)}"
    )
    print(
        "Order   : "
        + " → ".join(
            str(item["id"])
            for item in pages
        )
    )
    print(
        f"Output  : {output_file}"
    )
    print()


if __name__ == "__main__":
    generate_pdf()
