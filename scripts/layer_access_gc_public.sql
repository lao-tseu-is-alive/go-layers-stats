create table layer_access_gc_public
(
    id         serial not null,
    layer      text   not null,
    year       int    not null,
    month      int    not null,
    day        int    not null,
    hour_min   time   not null,
    ip_address text   not null,
    referer    text,
    user_agent text
);

create unique index layer_access_gc_public_id_uindex
    on layer_access_gc_internal (id);

alter table layer_access_gc_public
    add constraint layer_access_gc_public_pk
        primary key (id);

