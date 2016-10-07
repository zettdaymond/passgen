#include "whirlpoolhash.h"
#include <QMutexLocker>
#include <QVector>

WhirlpoolHash::WhirlpoolHash(QObject *parent) : QObject(parent), mutex()
{
    rhash_whirlpool_init(&w);
}

QVariantList WhirlpoolHash::hash(const QString& str)
{
    mutex.lock();
    auto s = str.toLatin1();
    auto size = s.size();
    auto cStr = reinterpret_cast<const unsigned char*> (s.data());
    rhash_whirlpool_init(&w);
    rhash_whirlpool_update(&w, cStr, size);
    unsigned char res[64];
    rhash_whirlpool_final(&w, res);
    mutex.unlock();

    QVariantList list;
    for(auto& c : res) {
        list << c;
    }

    return list;
}
