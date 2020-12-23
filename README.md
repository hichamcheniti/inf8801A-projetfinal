[PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
# Projet final - INF8801A

## Introduction
Pour rappel, notre projet final porte sur l'étude de l'article **Image Melding: Combining Inconsistent Images using Patch-based Synthesis**. Les différents algorithmes de cette étude se trouve dans le dossier *Image Melding*. Justement, nous comparerons l'algorithme *Image Cloning* de cette étude avec celui de la méthode de Poisson du laboratoire 2 (se trouvant dans le dossier *labo2*) que nous avons fait au cours de cette session d'automne 2020. Tout le code à été code en *Matlab*. 

## Environnement de travail
Dans le dossier *Image Melding*, on retrouve plusieurs fichiers, mais ceux qui nous intéresseront le plus sont les fichiers *ImageCloning.m* , *HoleFilling.m* et *TextureInterpolation.m*. Ces fichiers contiennent les algorithmes respectifs étudiés. Les autres fichiers sont les différents fichiers *do_EM_...* et *do_poisson_iterations*. Les fichiers *do_EM_...* sont utilisés pour faire les itérations de synthèse de base de leur algorithme respectif. Ils appellent à leur tour la fonction *do_poisson_iterations* pour résoudre la projection de l'équation de Poisson. On effectue environ 30 itérations par synthèses pour environ 10 mises à l'échelle.

Nous retrouvons aussi un dossier *Mexfiles* qui contient des fonctions sous forme de script *Matlab* permettant de chercher et de voter les différents patches pouvant remplir les zones à remplir de notre image de destination. 

Finalement, toujours dans le dossier *Image Melding* , il y a un dossier *Inputs* et un dossier *Results*. Le dossier *Inputs* contient les différentes images d'entrées pour chacun des algorithmes, dans leur dossier respectif. Le dossier *Results* contiendra lui les images intermédiaires et finales correspondantes créées lors de l'exécution d'un des trois algorithmes, toujours dans leur dossier respectif. 

L'autre dossier présent à la base de notre répertoire est le dossier *labo2*. Dans celui-ci, ce qui va nous intéresser, c'est le fichier **mainPoisson.m** présent dans le dossier *labo2\Inpainting\matlab*. Pour rappel, les images tests se trouvent dans le dossier *labo2\Inpainting\data\testPoisson*.

Dans les fichiers jugés les plus importants, des commentaires ont été ajoutés en espérant que cela vous aide dans votre compréhension du code. 

## Algorithmes étudiés 
La section suivante décrit brièvement chacun des trois algorithmes, ou plutôt comment bien les faires fonctionner. Des images tests et leurs résultats sont déjà fournis avec la remise du code. Vous pourriez toujours vous en inspirer et tenter de faire les tests avec vos propres images (et masques, si nécessaires). De plus, un fichier *other_results.pdf* à été ajouté dans le dossier *Results* afin que vous poussiez des résultats avec plusieurs autres images tests. 

### Hole Filling
Le premier algorithme est le *Hole Filling*, soit la complétion d'image à source unique. Pour l'exécuter, il suffit de lancer le fichier **HoleFilling.m**. Ce fichier à besoin uniquement d'une image source avec une zone magenta. 

### Image Cloning
Le deuxième algorithme est le *Image Cloning*, soit la reproduction d'éléments d'une image source vers une image de destination. Pour l'exécuter, il suffit de lancer le fichier **ImageCloning.m**. Essentielement, cet algorithme fait ce que l'algorithme *Poisson* du laboratoire 2 fait. Simplement, pour fonctionner, il a besoin de 4 images : une image source, une image de destination, un masque de couvrant la zone de l'image source à cloner et un masque de synthèse couvrant la zone à intégrer dans l'image de destination. Les deux masques doivent être de couleurs noir et blanc.  

### Texture Interpolation
Le troisième algorithme est le *Texture Interpolation*, soit l'interpolation de multiples textures pour la formation d'une image unique. Pour l'exécuter, il suffit de lancer le fichier **TextureInterpolation.m**. Ce fichier à besoin de deux images par exemple de textures différentes, et d'une autre image source (possiblement un panorama) contenant à ces extrémités les deux images différentes. Entre les deux images, il devrait y avoir une zone magenta a remplir. 

