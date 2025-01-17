# Generated by Django 5.1.3 on 2024-11-30 18:07

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('mattrix_usuarios', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='OA',
            fields=[
                ('id_OA', models.AutoField(primary_key=True, serialize=False)),
                ('OA', models.CharField(max_length=255)),
                ('descripcion', models.TextField()),
                ('nivel_asociado', models.CharField(choices=[('7° Básico', '7° Básico'), ('8° Básico', '8° Básico'), ('1° Medio', '1° Medio'), ('2° Medio', '2° Medio'), ('3° Medio', '3° Medio'), ('4° Medio', '4° Medio')], max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='ProblemaProbabilidad',
            fields=[
                ('id_problema', models.AutoField(primary_key=True, serialize=False)),
                ('tipo', models.CharField(max_length=50)),
                ('enunciado', models.TextField()),
                ('espacio_muestral', models.TextField()),
                ('elementos_evento', models.TextField()),
                ('numerador', models.IntegerField()),
                ('denominador', models.IntegerField()),
                ('creado_en', models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='TerminosPareados',
            fields=[
                ('id_termino', models.AutoField(primary_key=True, serialize=False)),
                ('uso', models.CharField(max_length=255)),
                ('concepto', models.CharField(max_length=255)),
                ('definicion', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Niveles',
            fields=[
                ('id_nivel', models.CharField(max_length=10, primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=255)),
                ('fondo', models.ForeignKey(blank=True, limit_choices_to={'uso': 'fondo-nivel'}, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='niveles', to='mattrix_usuarios.imagenes')),
                ('OA', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mattrix_contenido.oa')),
            ],
        ),
        migrations.CreateModel(
            name='IndicadoresEvaluacion',
            fields=[
                ('id_indicador', models.AutoField(primary_key=True, serialize=False)),
                ('descripcion', models.TextField()),
                ('contenido', models.TextField()),
                ('OA', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mattrix_contenido.oa')),
            ],
        ),
        migrations.CreateModel(
            name='Etapas',
            fields=[
                ('id_etapa', models.AutoField(primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=255)),
                ('descripcion', models.TextField()),
                ('componente', models.TextField()),
                ('dificultad', models.TextField(choices=[('Baja', 'Baja'), ('Intermedia', 'Intermedia'), ('Alta', 'Alta')], max_length=50)),
                ('habilidad', models.TextField(choices=[('Argumentar', 'Argumentar'), ('Modelar', 'Modelar'), ('Representrar', 'Representrar'), ('Resolución de problemas', 'Resolución de problemas')], max_length=50)),
                ('posicion_x', models.IntegerField()),
                ('posicion_y', models.IntegerField()),
                ('id_nivel', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mattrix_contenido.niveles')),
                ('OA', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mattrix_contenido.oa')),
            ],
        ),
    ]
