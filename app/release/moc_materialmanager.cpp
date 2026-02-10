/****************************************************************************
** Meta object code from reading C++ file 'materialmanager.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../materialmanager.h"
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'materialmanager.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.5.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSMaterialManagerENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSMaterialManagerENDCLASS = QtMocHelpers::stringData(
    "MaterialManager",
    "materialsChanged",
    "",
    "selectedMaterialChanged",
    "addMaterial",
    "name",
    "temperature",
    "flowRate",
    "duration",
    "removeMaterial",
    "index",
    "updateMaterial",
    "selectMaterial",
    "materials",
    "selectedMaterial"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSMaterialManagerENDCLASS_t {
    uint offsetsAndSizes[30];
    char stringdata0[16];
    char stringdata1[17];
    char stringdata2[1];
    char stringdata3[24];
    char stringdata4[12];
    char stringdata5[5];
    char stringdata6[12];
    char stringdata7[9];
    char stringdata8[9];
    char stringdata9[15];
    char stringdata10[6];
    char stringdata11[15];
    char stringdata12[15];
    char stringdata13[10];
    char stringdata14[17];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSMaterialManagerENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSMaterialManagerENDCLASS_t qt_meta_stringdata_CLASSMaterialManagerENDCLASS = {
    {
        QT_MOC_LITERAL(0, 15),  // "MaterialManager"
        QT_MOC_LITERAL(16, 16),  // "materialsChanged"
        QT_MOC_LITERAL(33, 0),  // ""
        QT_MOC_LITERAL(34, 23),  // "selectedMaterialChanged"
        QT_MOC_LITERAL(58, 11),  // "addMaterial"
        QT_MOC_LITERAL(70, 4),  // "name"
        QT_MOC_LITERAL(75, 11),  // "temperature"
        QT_MOC_LITERAL(87, 8),  // "flowRate"
        QT_MOC_LITERAL(96, 8),  // "duration"
        QT_MOC_LITERAL(105, 14),  // "removeMaterial"
        QT_MOC_LITERAL(120, 5),  // "index"
        QT_MOC_LITERAL(126, 14),  // "updateMaterial"
        QT_MOC_LITERAL(141, 14),  // "selectMaterial"
        QT_MOC_LITERAL(156, 9),  // "materials"
        QT_MOC_LITERAL(166, 16)   // "selectedMaterial"
    },
    "MaterialManager",
    "materialsChanged",
    "",
    "selectedMaterialChanged",
    "addMaterial",
    "name",
    "temperature",
    "flowRate",
    "duration",
    "removeMaterial",
    "index",
    "updateMaterial",
    "selectMaterial",
    "materials",
    "selectedMaterial"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSMaterialManagerENDCLASS[] = {

 // content:
      11,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       2,   78, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   50,    2, 0x06,    3 /* Public */,
       3,    0,   51,    2, 0x06,    4 /* Public */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
       4,    4,   52,    2, 0x02,    5 /* Public */,
       9,    1,   61,    2, 0x02,   10 /* Public */,
      11,    5,   64,    2, 0x02,   12 /* Public */,
      12,    1,   75,    2, 0x02,   18 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::Int, QMetaType::Int, QMetaType::Int,    5,    6,    7,    8,
    QMetaType::Void, QMetaType::Int,   10,
    QMetaType::Void, QMetaType::Int, QMetaType::QString, QMetaType::Int, QMetaType::Int, QMetaType::Int,   10,    5,    6,    7,    8,
    QMetaType::Void, QMetaType::Int,   10,

 // properties: name, type, flags
      13, QMetaType::QVariantList, 0x00015001, uint(0), 0,
      14, QMetaType::QVariantMap, 0x00015001, uint(1), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject MaterialManager::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_CLASSMaterialManagerENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSMaterialManagerENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSMaterialManagerENDCLASS_t,
        // property 'materials'
        QtPrivate::TypeAndForceComplete<QVariantList, std::true_type>,
        // property 'selectedMaterial'
        QtPrivate::TypeAndForceComplete<QVariantMap, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<MaterialManager, std::true_type>,
        // method 'materialsChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'selectedMaterialChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'addMaterial'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'removeMaterial'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'updateMaterial'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'selectMaterial'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>
    >,
    nullptr
} };

void MaterialManager::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<MaterialManager *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->materialsChanged(); break;
        case 1: _t->selectedMaterialChanged(); break;
        case 2: _t->addMaterial((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[4]))); break;
        case 3: _t->removeMaterial((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 4: _t->updateMaterial((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[4])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[5]))); break;
        case 5: _t->selectMaterial((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (MaterialManager::*)();
            if (_t _q_method = &MaterialManager::materialsChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (MaterialManager::*)();
            if (_t _q_method = &MaterialManager::selectedMaterialChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
    }else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<MaterialManager *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QVariantList*>(_v) = _t->materials(); break;
        case 1: *reinterpret_cast< QVariantMap*>(_v) = _t->selectedMaterial(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    } else if (_c == QMetaObject::BindableProperty) {
    }
}

const QMetaObject *MaterialManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MaterialManager::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSMaterialManagerENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int MaterialManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 6;
    }else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void MaterialManager::materialsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void MaterialManager::selectedMaterialChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
