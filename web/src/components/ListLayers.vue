<style>
.align-right {
  text-align: right !important;
}
.align-center {
  text-align: center;
}
.p-datatable th[class*="align-center"] .p-column-header-content {
  justify-content: center;
}
.p-datatable td[class*="align-right"] .p-column-header-content {
  justify-content: end;
  text-align: right;
}
.cg-centered-header {
  justify-content: center;
  align-content: center;
  background-color: blue;
}
</style>

<template>
  <div class="w-full">
    <DataTable
      :value="data"
      removableSort
      v-model:filters="filters"
      responsiveLayout="scroll"
    >
      <template #header>
        <div class="flex align-items-center justify-content-between">
          <h2 class="m-2">{{ msg }}</h2>
          <span class="p-input-icon-left right-0">
            <i class="pi pi-search" />
            <InputText
              v-model="filters['global'].value"
              placeholder="filtre de couche"
            />
          </span>
        </div>
      </template>
      <ColumnGroup type="header">
        <Row>
          <Column
            field="layer"
            header="Couche"
            :colspan="1"
            :rowspan="2"
            :sortable="true"
          />
          <Column header="GC interne" :colspan="2" class="align-center" />
          <Column header="GC public" :colspan="2" class="align-center" />
        </Row>
        <Row>
          <Column field="requests_gc_internal" header="hits" :sortable="true" />
          <Column
            field="visits_gc_internal"
            header="visitors"
            :sortable="true"
          />
          <Column field="requests_gc_public" header="hits" :sortable="true" />
          <Column field="visits_gc_public" header="visitors" :sortable="true" />
        </Row>
      </ColumnGroup>
      <Column field="layer" />
      <Column field="requests_gc_internal" class="align-right" />
      <Column field="visits_gc_internal" class="align-right"/>
      <Column field="requests_gc_public" class="align-right"/>
      <Column field="visits_gc_public" class="align-right"/>
    </DataTable>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import ColumnGroup from "primevue/columngroup";
import Row from "primevue/row";
import InputText from "primevue/inputtext";
import { FilterMatchMode, FilterOperator } from "primevue/api";

const loading = ref(true);
const data = ref([
  {
    layer: "altimetrie_courbes_niveau_msgroup",
    requests_gc_internal: 17,
    visits_gc_internal: 5,
    requests_gc_public: 71,
    visits_gc_public: 14,
  },
]);
const error = ref(null);
const filters = ref({
  global: { value: null, matchMode: FilterMatchMode.CONTAINS },
  layer: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.STARTS_WITH }],
  },
});

function fetchLayersData(url = "/layers_stats.json") {
  const method = `fetchLayersData(${url})`;
  console.log(`##--> ${method}`);
  loading.value = true;
  return fetch(url, {
    method: "get",
    headers: {
      "content-type": "application/json",
    },
  })
    .then((response) => {
      if (!response.ok) {
        console.log(`#💥💥 ERROR in ${method}, status: ${response.status}`);
        const error = new Error(response.statusText);
        error.json = response.json();
        throw error;
      }
      console.log(`# ${method}, after fetch, status ${response.status}`);
      return response.json();
    })
    .then((json) => {
      console.log(`# ${method}, after json() ${typeof json}`);
      if (json instanceof Array) {
        data.value = json;
      } else {
        error.value = `# ${method}, json is not an instanceof Array`;
      }
    })
    .catch((err) => {
      console.log(`#💥💥 ERROR in ${method}, catch err:${err}`);
      error.value = err;
      // In case a custom JSON error response was provided
      if (err.json) {
        return err.json.then((json) => {
          // set the JSON response message
          error.value.message = json.message;
        });
      }
    })
    .then(() => {
      loading.value = false;
    });
}

onMounted(() => {
  const method = "onMounted";
  console.log(`##--> ${method}`);
  fetchLayersData();
});

defineProps({
  msg: {
    type: String,
    required: true,
  },
});
</script>
