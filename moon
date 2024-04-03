import ephem
import requests
from PIL import Image, ImageEnhance
from io import BytesIO

def calcular_fase_lunar():
    observer = ephem.Observer()
    observer.date = ephem.now()
    moon = ephem.Moon(observer)
    return moon.phase

def obtener_nombre_fase(fase_lunar):
    if 0 <= fase_lunar < 7.4:
        return 'Luna Nueva'
    elif 7.4 <= fase_lunar < 14.8:
        return 'Cuarto Creciente'
    elif 14.8 <= fase_lunar < 22.1:
        return 'Gibosa Creciente'
    elif 22.1 <= fase_lunar < 29.5:
        return 'Luna Llena'
    elif 29.5 <= fase_lunar < 36.9:
        return 'Gibosa Menguante'
    elif 36.9 <= fase_lunar < 44.2:
        return 'Cuarto Menguante'
    else:
        return 'Fase Desconocida'

def cargar_imagen_luna(fase_lunar):
    try:
        # URL específica para la fase lunar
        url_imagen = f'https://source.unsplash.com/featured/?moon,{fase_lunar.lower()}'
        respuesta = requests.get(url_imagen)
        respuesta.raise_for_status()
        imagen = Image.open(BytesIO(respuesta.content)).convert('L')  # Convertir a escala de grises
        return imagen
    except requests.exceptions.RequestException as req_err:
        print(f"Error al hacer la solicitud: {req_err}")
    except Exception as e:
        print(f"Error al cargar la imagen: {e}")
    return None

def ajustar_contraste_saturacion(imagen):
    enhancer = ImageEnhance.Contrast(imagen)
    imagen = enhancer.enhance(2.0)  # Ajustar según tus preferencias

    enhancer = ImageEnhance.Color(imagen)
    imagen = enhancer.enhance(0.0)  # Convertir a blanco y negro

    return imagen

def recomendar_cosecha(nombre_fase):
    # Diccionario de recomendaciones de cosecha para cada fase lunar
    recomendaciones = {
        'Luna Nueva': {
            'recomendacion': 'No recomendado para la cosecha, ya que la luz es mínima.',
            'tipo_cosecha': 'No es buen momento para cosechar.',
        },
        'Cuarto Creciente': {
            'recomendacion': 'Buen momento para cosechar cultivos que crecen sobre la tierra.',
            'tipo_cosecha': 'Cosecha de cultivos sobre la tierra.',
        },
        'Gibosa Creciente': {
            'recomendacion': 'Período favorable para cosechar y transplantar.',
            'tipo_cosecha': 'Cosecha y trasplante de cultivos.',
        },
        'Luna Llena': {
            'recomendacion': 'Evitar la cosecha ya que la savia se encuentra en las raíces.',
            'tipo_cosecha': 'Evitar la cosecha.',
        },
        'Gibosa Menguante': {
            'recomendacion': 'Buen momento para cosechar y almacenar cultivos.',
            'tipo_cosecha': 'Cosecha y almacenamiento de cultivos.',
        },
        'Cuarto Menguante': {
            'recomendacion': 'Buen momento para cosechar cultivos de raíz.',
            'tipo_cosecha': 'Cosecha de cultivos de raíz.',
        },
        'Fase Desconocida': {
            'recomendacion': 'Fase desconocida. Consulte con un experto en agricultura.',
            'tipo_cosecha': 'No se puede determinar el tipo de cosecha.',
        },
    }

    # Obtener la recomendación para la fase lunar actual
    recomendacion = recomendaciones.get(nombre_fase, recomendaciones['Fase Desconocida'])

    return recomendacion

def mostrar_resultado():
    fase_lunar = calcular_fase_lunar()
    nombre_fase = obtener_nombre_fase(fase_lunar)
    recomendacion = recomendar_cosecha(nombre_fase)
    print(f"Fase Lunar: {nombre_fase}")
    print(f"Recomendación de Cosecha: {recomendacion['recomendacion']}")
    print(f"Tipo de Cosecha: {recomendacion['tipo_cosecha']}")

mostrar_resultado()



