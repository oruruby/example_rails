<template>
    <div>
    <div>
        <div>
            Name: <input type="text" v-model="form.name">
        </div>
        <div>
            <input v-if="!editingId" type="button" @click="createRecord" value="Создать">
            <input v-if="editingId" type="button" @click="updateRecord" value="Обновить">
            <input v-if="editingId" type="button" @click="cancelEditRecord" value="Отменить">
        </div>
    </div>
    <table>
        <thead>
            <th>Имя</th>
            <th>Действия</th>
        </thead>
        <tbody>
            <tr
                v-for="rec in records" :key="rec.id"
            >
                <td>
                    {{ rec.name }}
                </td>
                <td>
                    <a href="#" @click="deleteRecord(rec.id)">Удалить</a>
                    <a href="#" @click="editRecord(rec)">Редактировать</a>
                </td>
            </tr>
        </tbody>
        <div>
        </div>
    </table>
    </div>
</template>
<script>
    export default {
        data: () => {
            return {
                records: [],
                record: null,
                form: {
                    name: ''
                },
                editingId: null
            }
        },
        mounted(){
            this.$cable.subscribe({
                channel: 'ProductChannel',
                room: 'myuid'
            }, 'action_channel');

            this.$cable.subscribe({
                channel: 'ProductChannel',
                room: 'public'
            }, 'record_channel');
        },
        methods: {

            /************************\
            |   COMPONENT ACTIONS    |
            \************************/

            editRecord(rec){
                this.editingId = rec.id
                this.form.name = rec.name
            },

            cancelEditRecord(){
                this.form = {name: ''}
                this.editingId = null
            },

            /************************\
            |  ACTION CABLE ACTIONS  |
            \************************/

            getRecords(){
                this.broadcastAction('index')
            },

            getRecord(id, variant = "for_show"){ //for_index, for_show
                this.broadcastAction('show', {id, variant})
            },

            createRecord(){
                this.broadcastAction('create', {form: this.form})
            },

            updateRecord(){
                this.broadcastAction('update', {form: this.form, id: this.editingId})
            },

            deleteRecord(id){
                this.broadcastAction('delete', {id})
            },

            /************************\
            | ACTION CABLE CALLBACKS |
            \************************/

            afterGetRecords(records){
                this.records = records
            },

            afterGetRecord(record){
                const findedRecord = this.records.filter( irecord => record.id == irecord.id )
                if(findedRecord){
                    this.records = this.records.map( irecord => record.id == irecord.id ? record : irecord )
                }else{
                    this.records = [...this.records].unshift(record)
                }
            },

            afterCreateRecord(data){
                data
                this.form = {name: ''}
            },

            afterUpdateRecord(){
                this.form = {name: ''}
                this.editingId = null
            },

            afterDeleteRecord(data){
                data
            },

            notifyCreate(id){
                id
                // TODO: Add some logic for pagination and quering on models
                this.getRecords()
            },

            notifyUpdate(id){
                // TODO: Add some logic for quering on models
                this.getRecord(id, "for_index")
            },

            notifyDelete(id){
                // TODO: Add some logic for pagination
                this.records = this.records.filter( irecord => id != irecord.id )
            },

            /************************\
            |      META ACTIONS      |
            \************************/

            broadcastAction(method, params = null){
                this.$cable.perform({
                    channel: 'action_channel',
                    action: method,
                    data: params
                })
            },
            actionResolvers(){
                return {
                    index: records => this.afterGetRecords(records),
                    delete: data => this.afterDeleteRecord(data),
                    create: data => this.afterCreateRecord(data),
                    update: data => this.afterUpdateRecord(data),
                    show: record => this.afterGetRecord(record),
                }
            },
            recordResolvers(){
                return {
                    create: id => this.notifyCreate(id),
                    update: id => this.notifyUpdate(id),
                    delete: id => this.notifyDelete(id)
                }
            }
        },
        channels: {
            action_channel: {
                received(data) {
                   this.actionResolvers()[data.action](data.data)
                },
                connected() {
                    this.getRecords()
                },
                rejected() {
                    //
                },
                disconnected() {
                    //
                }
            },
            record_channel: {
                received(data){
                    this.recordResolvers()[data.action](data.data)
                },
                connected(){
                    //
                },
                rejected(){
                    //
                },
                disconnected(){
                    //
                }
            }
        },
    }
</script>
<styles></styles>