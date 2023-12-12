from io import BytesIO
from typing_extensions import Literal
from fpdf import FPDF
import qrcode


class PDF(FPDF):
    
    def __init__(self, orientation='P', unit='mm', format='A4') -> None:
        super().__init__(orientation, unit, format)
        self.quant_etiquetas = 0
        self.add_page()

    def header(self):
        pass

    def footer(self):
        pass

    def add_product(self, qr_code_path, product_name, product_price):

        if self.quant_etiquetas == 27:
            self.add_page()
            self.quant_etiquetas = 0

        # Adiciona QR code à esquerda
        self.image(qr_code_path, x=self.quant_etiquetas % 3 * 70, y=self.quant_etiquetas // 3 * 30, w=30, h=30)


        # Adiciona nome do produto à direita
        self.set_font("Arial", "B", 8)
        self.set_xy(x=(self.quant_etiquetas % 3 * 70) + 32, y=(self.quant_etiquetas // 3 * 30) + 5)
        self.multi_cell(35, 3, product_name)

        # Adiciona preço abaixo do nome do produto
        self.set_font("Arial", "B", 12)
        self.set_xy(x=(self.quant_etiquetas % 3 * 70) + 32, y=(self.quant_etiquetas // 3 * 30) + 18)
        self.cell(0, 10, product_price)
        self.quant_etiquetas += 1


# Função para gerar QR code e salvar em um arquivo
def generate_qr_code(data, qrcode_path):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    img.save(qrcode_path, format='PNG')
    

