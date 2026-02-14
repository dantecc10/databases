#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FILE_PATH "alumnos.dat"
typedef struct
{
    int id;
    char name[50];
    char last_names[60];
    int age;
    int matricula_number;
} alumno;

int main()
{
    int option = 0;
    FILE *file = fopen(FILE_PATH, "wb+");

    if (file == NULL)
    {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    // Menú de opciones
    while (option != 5)
    {
        printf("1. Agregar alumno\n");
        printf("2. Consultar alumnos\n");
        printf("3. Modificar alumno\n");
        printf("4. Eliminar alumno\n");
        printf("5. Salir\n");
        printf("Seleccione una opción: ");
        scanf("%d", &option);

        switch (option)
        {
        case 1:
            alumno adding_student = {};
            printf("Ingrese el nombre del alumno: ");
            scanf("%s", adding_student.name);
            printf("Ingrese los apellidos del alumno: ");
            scanf("%s", adding_student.last_names);
            printf("Ingrese la edad del alumno: ");
            scanf("%d", &adding_student.age);
            printf("Ingrese el número de matrícula del alumno: ");
            scanf("%d", &adding_student.matricula_number);
            fwrite(&adding_student, sizeof(alumno), 1, file);
            break;

        case 2:
            rewind(file);
            alumno student;
            while (fread(&student, sizeof(alumno), 1, file) == 1)
            {
                printf("ID: %d\n", student.id);
                printf("Nombre: %s\n", student.name);
                printf("Apellidos: %s\n", student.last_names);
                printf("-------------------------\n");
                printf("¿Desea ver detalles del alumno? (1 para sí, 0 para no): ");
                int view_details;
                scanf("%d", &view_details);
                if (view_details)
                {
                    printf("Indique el ID del alumno para ver detalles: ");
                    int id_to_view;
                    scanf("%d", &id_to_view);
                    if (student.id == id_to_view)
                    {
                        printf("ID: %d\n", student.id);
                        printf("Nombre: %s\n", student.name);
                        printf("Apellidos: %s\n", student.last_names);
                        printf("Edad: %d\n", student.age);
                        printf("Número de matrícula: %d\n", student.matricula_number);
                    }
                    else
                    {
                        printf("Alumno no encontrado.\n");
                    }
                }
                // Volver al menú
                break;
            }
        case 3:
            // Implementar lógica para modificar alumno
            while (fread(&student, sizeof(alumno), 1, file) == 1)
            {
                printf("Mostrando alumnos para modificar:\n");
                printf("ID: %d\n", student.id);
                printf("Nombre: %s\n", student.name);
                printf("Apellidos: %s\n", student.last_names);
                printf("-------------------------\n");

                printf("Indique el ID del alumno para ver detalles: ");
                int id_to_view;
                char temp_name[50];
                char temp_last_names[60];
                int temp_age;
                int temp_matricula_number;
                scanf("%d", &id_to_view);
                if (student.id == id_to_view)
                {
                    printf("Ingrese el nuevo valor de nombre del alumno: ");
                    (scanf("%s", temp_name) != NULL) ? strcpy(student.name, temp_name) : printf("Valor no modificado.\n");
                    printf("Ingrese el nuevo valor de apellidos del alumno: ");
                    (scanf("%s", temp_last_names) != NULL) ? strcpy(student.last_names, temp_last_names) : printf("Valor no modificado.\n");
                    printf("Ingrese el nuevo valor de edad del alumno: ");
                    (scanf("%d", &temp_age) != NULL) ? student.age = temp_age : printf("Valor no modificado.\n");
                    printf("Ingrese el nuevo valor de número de matrícula del alumno: ");
                    (scanf("%d", &temp_matricula_number) != NULL) ? student.matricula_number = temp_matricula_number : printf("Valor no modificado.\n");

                    printf("Alumno modificado:\n");
                    printf("ID: %d\n", student.id);
                    printf("Nombre: %s\n", student.name);
                    printf("Apellidos: %s\n", student.last_names);
                    printf("Edad: %d\n", student.age);
                    printf("Número de matrícula: %d\n", student.matricula_number);
                    fwrite(&student, sizeof(alumno), 1, file);
                }
                else
                {
                    printf("Alumno no encontrado.\n");
                }

                break;
            }
        case 4:
            // Implementar lógica para eliminar alumno
            while (fread(&student, sizeof(alumno), 1, file) == 1)
            {
                printf("Mostrando alumnos para eliminar:\n");
                printf("ID: %d\n", student.id);
                printf("Nombre: %s\n", student.name);
                printf("Apellidos: %s\n", student.last_names);
                printf("-------------------------\n");
            }
            printf("Indique el ID del alumno para eliminar: ");
            int id_to_delete;
            scanf("%d", &id_to_delete);
            if (student.id == id_to_delete)
            {
                printf("Alumno eliminado:\n");
                printf("ID: %d\n", student.id);
                printf("Nombre: %s\n", student.name);
                printf("Apellidos: %s\n", student.last_names);
                printf("Edad: %d\n", student.age);
                printf("Número de matrícula: %d\n", student.matricula_number);
                // Para eliminar, simplemente no escribir el alumno en el archivo
            }
            else
            {
                printf("Alumno no encontrado.\n");
            }
            break;

        case 5:
            printf("Saliendo del programa...\n");
            break;

        default:
            printf("Opción no válida. Por favor, seleccione una opción del 1 al 5.\n");
            break;
        }
    }
}