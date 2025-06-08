bool isImage(String mimetype) =>
    (['image/jpeg', 'image/jpg', 'image/png'].contains(mimetype));

bool isSVG(String mimetype) => (['image/svg+xml'].contains(mimetype));
