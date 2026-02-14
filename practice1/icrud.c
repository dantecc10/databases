#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FILE_PATH "trabajadores.dat"

typedef struct
{
    int id;
    char name[50];
    char last_names[60];
    int age;
    char phone_number[11];
} trabajador;

static void readLine(const char *prompt, char *buffer, size_t size)
{
    printf("%s", prompt);
    if (fgets(buffer, (int)size, stdin) == NULL)
    {
        clearerr(stdin);
        buffer[0] = '\0';
        return;
    }
    buffer[strcspn(buffer, "\n")] = '\0';
}

static int readInt(const char *prompt)
{
    char buffer[64];
    char *end = NULL;
    long value = 0;
    while (1)
    {
        printf("%s", prompt);
        if (fgets(buffer, sizeof(buffer), stdin) == NULL)
        {
            clearerr(stdin);
            continue;
        }
        value = strtol(buffer, &end, 10);
        if (end == buffer)
        {
            printf("Entrada inválida. Intente de nuevo.\n");
            continue;
        }
        return (int)value;
    }
}

static int readIntOptional(const char *prompt, int *value)
{
    char buffer[64];
    char *end = NULL;
    printf("%s", prompt);
    if (fgets(buffer, sizeof(buffer), stdin) == NULL)
    {
        clearerr(stdin);
        return 0; // Keep existing value
    }
    // If user just pressed enter (empty line), keep existing value
    if (buffer[0] == '\n' || buffer[0] == '\0')
    {
        return 0;
    }
    long new_value = strtol(buffer, &end, 10);
    if (end == buffer)
    {
        printf("Entrada inválida. Se mantendrá el valor actual.\n");
        return 0;
    }
    *value = (int)new_value;
    return 1; // Value was changed
}

int getLastId(FILE *file)
{
    rewind(file);
    trabajador worker;
    if (fread(&worker, sizeof(trabajador), 1, file) == 0)
        return 0; // If the file is empty
    int last_id = worker.id;
    while (fread(&worker, sizeof(trabajador), 1, file) == 1)
    {
        last_id = worker.id;
    }
    return last_id;
}

void addtrabajador(FILE *file)
{
    trabajador adding_worker;
    adding_worker.id = getLastId(file) + 1; // Auto-increment ID
    readLine("Ingrese el nombre del trabajador: ", adding_worker.name, sizeof(adding_worker.name));
    readLine("Ingrese los apellidos del trabajador: ", adding_worker.last_names, sizeof(adding_worker.last_names));
    adding_worker.age = readInt("Ingrese la edad del trabajador: ");
    readLine("Ingrese el número de teléfono del trabajador (10 dígitos): ", adding_worker.phone_number, sizeof(adding_worker.phone_number));
    fwrite(&adding_worker, sizeof(trabajador), 1, file);
    fflush(file);
    printf("Trabajador agregado exitosamente.\n");
}

void viewtrabajador(FILE *file, int id)
{
    rewind(file);
    trabajador worker;
    while (fread(&worker, sizeof(trabajador), 1, file) == 1)
    {
        if (worker.id == id)
        {
            printf("ID: %d\n", worker.id);
            printf("Nombre: %s\n", worker.name);
            printf("Apellidos: %s\n", worker.last_names);
            printf("Edad: %d\n", worker.age);
            printf("Número de teléfono: %s\n", worker.phone_number);
            return;
        }
    }
    printf("Trabajador no encontrado.\n");
}

void modifytrabajador(FILE *file)
{
    int id_to_modify = readInt("Indique el ID del trabajador para modificar: ");
    rewind(file);
    trabajador worker;
    while (fread(&worker, sizeof(trabajador), 1, file) == 1)
    {
        if (worker.id == id_to_modify)
        {
            char temp_buffer[100];

            printf("Nombre actual: %s\n", worker.name);
            readLine("Ingrese el nuevo nombre (Enter para mantener): ", temp_buffer, sizeof(temp_buffer));
            if (temp_buffer[0] != '\0')
            {
                strncpy(worker.name, temp_buffer, sizeof(worker.name) - 1);
                worker.name[sizeof(worker.name) - 1] = '\0';
            }

            printf("Apellidos actuales: %s\n", worker.last_names);
            readLine("Ingrese los nuevos apellidos (Enter para mantener): ", temp_buffer, sizeof(temp_buffer));
            if (temp_buffer[0] != '\0')
            {
                strncpy(worker.last_names, temp_buffer, sizeof(worker.last_names) - 1);
                worker.last_names[sizeof(worker.last_names) - 1] = '\0';
            }

            printf("Edad actual: %d\n", worker.age);
            readIntOptional("Ingrese la nueva edad (Enter para mantener): ", &worker.age);

            printf("Número de teléfono actual: %s\n", worker.phone_number);
            readLine("Ingrese el nuevo número de teléfono (Enter para mantener): ", temp_buffer, sizeof(temp_buffer));
            if (temp_buffer[0] != '\0')
            {
                strncpy(worker.phone_number, temp_buffer, sizeof(worker.phone_number) - 1);
                worker.phone_number[sizeof(worker.phone_number) - 1] = '\0';
            }

            fseek(file, -sizeof(trabajador), SEEK_CUR); // Move cursor back to overwrite the record
            fwrite(&worker, sizeof(trabajador), 1, file);
            fflush(file);
            printf("Trabajador modificado exitosamente.\n");
            return;
        }
    }
    printf("Trabajador no encontrado.\n");
}

FILE *deletetrabajador(FILE *file)
{
    int id_to_delete = readInt("Indique el ID del trabajador para eliminar: ");
    FILE *tempFile = fopen("temp.dat", "wb");
    rewind(file);
    trabajador worker;
    int found = 0;
    while (fread(&worker, sizeof(trabajador), 1, file) == 1)
    {
        if (worker.id != id_to_delete)
        {
            fwrite(&worker, sizeof(trabajador), 1, tempFile);
        }
        else
        {
            found = 1;
            printf("Trabajador eliminado:\n");
            printf("ID: %d\n", worker.id);
            printf("Nombre: %s\n", worker.name);
            printf("Apellidos: %s\n", worker.last_names);
            printf("Edad: %d\n", worker.age);
            printf("Número de teléfono: %s\n", worker.phone_number);
        }
    }
    fclose(file);
    fclose(tempFile);
    remove("trabajadores.dat");
    rename("temp.dat", "trabajadores.dat");

    if (!found)
    {
        printf("Trabajador no encontrado.\n");
    }

    // Reopen the file for continued use
    file = fopen(FILE_PATH, "rb+");
    if (file == NULL)
    {
        file = fopen(FILE_PATH, "wb+");
    }
    return file;
}

int main()
{
    FILE *file = fopen(FILE_PATH, "rb+");
    if (file == NULL)
    {
        file = fopen(FILE_PATH, "wb+");
        if (file == NULL)
        {
            perror("Error opening file");
            return EXIT_FAILURE;
        }
    }

    int option = 0;
    while (option != 5)
    {
        printf("\n1. Agregar trabajador\n");
        printf("2. Consultar trabajadores\n");
        printf("3. Modificar trabajador\n");
        printf("4. Eliminar trabajador\n");
        printf("5. Salir\n");
        option = readInt("Seleccione una opción: ");

        switch (option)
        {
        case 1:
            addtrabajador(file);
            break;
        case 2:
        {
            rewind(file);
            trabajador worker;
            while (fread(&worker, sizeof(trabajador), 1, file) == 1)
            {
                printf("ID: %d\n", worker.id);
                printf("Nombre: %s\n", worker.name);
                printf("Apellidos: %s\n", worker.last_names);
                printf("-------------------------\n");
            }
            int view_details = readInt("¿Desea ver detalles del trabajador? (1 para sí, 0 para no): ");
            if (view_details)
            {
                int id_to_view = readInt("Indique el ID del trabajador para ver detalles: ");
                viewtrabajador(file, id_to_view);
            }
            break;
        }
        case 3:
            modifytrabajador(file);
            break;
        case 4:
            file = deletetrabajador(file);
            break;
        case 5:
            printf("Saliendo del programa...\n");
            break;
        default:
            printf("Opción no válida. Por favor, seleccione una opción del 1 al 5.\n");
            break;
        }
    }
    fclose(file);
    return 0;
}