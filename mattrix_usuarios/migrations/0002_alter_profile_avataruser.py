# Generated by Django 5.1.3 on 2024-11-30 18:39

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mattrix_usuarios', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='avatarUser',
            field=models.ForeignKey(blank=True, default='1', null=True, on_delete=django.db.models.deletion.SET_NULL, to='mattrix_usuarios.imagenes'),
        ),
    ]
