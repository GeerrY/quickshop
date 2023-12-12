from PIL import Image
import io


def crop_center_to_square(image):
    # Abrir a imagem
    image = Image.open(image)

    # Obter as dimensões da imagem
    width, height = image.size

    # Calcular o tamanho do lado do quadrado
    size = min(width, height)

    # Calcular as coordenadas para cortar o centro da imagem
    left = (width - size) / 2
    top = (height - size) / 2
    right = (width + size) / 2
    bottom = (height + size) / 2

    # Cortar o centro da imagem
    cropped_image = image.crop((left, top, right, bottom))

    return cropped_image


